module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] q_reg;
    reg [15:0] q_next;
    reg [2:0] ena_reg;
    reg [2:0] ena_next;

    always @(*) begin
        // Calculate next state
        q_next = q_reg;
        ena_next = 3'b000;

        // Check if we need to increment each digit
        if (q_reg[3:0] == 4'd9) begin
            q_next[3:0] = 4'd0;
            ena_next[0] = 1'b1;
        end else begin
            q_next[3:0] = q_reg[3:0] + 1'b1;
        end

        if (ena_next[0] == 1'b1 && q_reg[7:4] == 4'd9) begin
            q_next[7:4] = 4'd0;
            ena_next[1] = 1'b1;
        end else if (ena_next[0] == 1'b1) begin
            q_next[7:4] = q_reg[7:4] + 1'b1;
        end

        if (ena_next[1] == 1'b1 && q_reg[11:8] == 4'd9) begin
            q_next[11:8] = 4'd0;
            ena_next[2] = 1'b1;
        end else if (ena_next[1] == 1'b1) begin
            q_next[11:8] = q_reg[11:8] + 1'b1;
        end

        if (ena_next[2] == 1'b1 && q_reg[15:12] == 4'd9) begin
            q_next[15:12] = 4'd0;
        end else if (ena_next[2] == 1'b1) begin
            q_next[15:12] = q_reg[15:12] + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            // Synchronous active-high reset
            q_reg <= 16'd0;
            ena_reg <= 3'b000;
        end else begin
            q_reg <= q_next;
            ena_reg <= ena_next;
        end
    end

    assign q = q_reg;
    assign ena = ena_reg;

endmodule