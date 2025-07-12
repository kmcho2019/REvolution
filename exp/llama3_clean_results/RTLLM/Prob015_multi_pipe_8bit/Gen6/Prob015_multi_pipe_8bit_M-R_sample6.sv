module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [1:0] state;
reg mul_en_out_reg;

// State Machine
always @(posedge clk) begin
    if (~rst_n) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (mul_en_in) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                state <= 2'b10;
            end
            2'b10: begin
                state <= 2'b11;
            end
            2'b11: begin
                state <= 2'b00;
            end
        endcase
    end
end

// Input Registers
always @(posedge clk) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (state == 2'b00 && mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Output Registers
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (state == 2'b10) begin
        mul_out_reg <= 16'b0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                mul_out_reg <= mul_out_reg + (mul_a_reg << i);
            end
        end
    end
end

// Output Enable Signal
always @(posedge clk) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (mul_en_in) begin
                    mul_en_out_reg <= 1'b1;
                end
            end
            2'b11: begin
                mul_en_out_reg <= 1'b0;
            end
        endcase
    end
end

// Output Assignment
assign mul_en_out = (state == 2'b10 || state == 2'b11) ? mul_en_out_reg : 1'b0;
assign mul_out = (state == 2'b11) ? mul_out_reg : 16'b0;

endmodule