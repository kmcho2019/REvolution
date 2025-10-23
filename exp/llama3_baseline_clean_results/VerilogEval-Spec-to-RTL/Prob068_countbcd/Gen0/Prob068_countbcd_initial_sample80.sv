module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] q_reg;
reg [2:0] ena_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 16'd0;
        ena_reg <= 3'd0;
    end else begin
        // Initialize enable signals to 0
        ena_reg <= 3'd0;

        // Increment ones digit
        if (q_reg[3:0] == 4'd9) begin
            q_reg[3:0] <= 4'd0;
            ena_reg[0] <= 1'b1; // Enable tens digit
        end else begin
            q_reg[3:0] <= q_reg[3:0] + 1'd1;
        end

        // Increment tens digit
        if (ena_reg[0] == 1'b1 && q_reg[7:4] == 4'd9) begin
            q_reg[7:4] <= 4'd0;
            ena_reg[1] <= 1'b1; // Enable hundreds digit
        end else if (ena_reg[0] == 1'b1) begin
            q_reg[7:4] <= q_reg[7:4] + 1'd1;
        end

        // Increment hundreds digit
        if (ena_reg[1] == 1'b1 && q_reg[11:8] == 4'd9) begin
            q_reg[11:8] <= 4'd0;
            ena_reg[2] <= 1'b1; // Enable thousands digit
        end else if (ena_reg[1] == 1'b1) begin
            q_reg[11:8] <= q_reg[11:8] + 1'd1;
        end

        // Increment thousands digit
        if (ena_reg[2] == 1'b1) begin
            if (q_reg[15:12] == 4'd9) begin
                q_reg[15:12] <= 4'd0;
            end else begin
                q_reg[15:12] <= q_reg[15:12] + 1'd1;
            end
        end
    end

    // Assign output signals
    ena <= ena_reg;
    q <= q_reg;
end

endmodule