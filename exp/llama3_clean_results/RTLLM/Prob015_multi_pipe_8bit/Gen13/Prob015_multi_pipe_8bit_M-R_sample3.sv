module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [1:0] state;
reg [2:0] counter;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] partial_product [7:0];
reg [15:0] partial_sum;
reg [15:0] mul_out_reg;

// FSM
always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'b00; // idle
        counter <= 3'b000;
    end else begin
        case (state)
            2'b00: begin // idle
                if (mul_en_in) begin
                    state <= 2'b01; // multiply
                    counter <= 3'b001;
                end
            end
            2'b01: begin // multiply
                if (counter == 7) begin
                    state <= 2'b10; // done
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b10: begin // done
                if (!mul_en_in) begin
                    state <= 2'b00; // idle
                end
            end
        endcase
    end
end

// Input Buffering
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign partial_product[i] = (mul_b_reg[i]) ? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Partial Sum Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (state == 2'b01) begin
        partial_sum <= (counter == 0) ? partial_product[0] : partial_sum + partial_product[counter];
    end
end

// Final Product Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (state == 2'b01) begin
        mul_out_reg <= partial_sum;
    end
end

// Output assignment
assign mul_en_out = (state == 2'b10) ? 1'b1 : 1'b0;
assign mul_out = (state == 2'b10) ? mul_out_reg : 16'b0;

endmodule