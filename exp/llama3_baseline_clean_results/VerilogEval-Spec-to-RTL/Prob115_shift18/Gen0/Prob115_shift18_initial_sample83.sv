module TopModule(
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output [63:0] q
    );

reg [63:0] q_reg;

always @(posedge clk) begin
    if(load) begin
        q_reg <= data;
    end else if(ena) begin
        case(amount)
            2'b00: begin
                q_reg <= {q_reg[62:0], 1'b0}; // shift left by 1 bit
            end
            2'b01: begin
                q_reg <= {q_reg[55:0], 8'b0}; // shift left by 8 bits
            end
            2'b10: begin
                q_reg <= {q_reg[63], q_reg[63:1]}; // arithmetic right shift by 1 bit
            end
            2'b11: begin
                q_reg <= {8{q_reg[63]}, q_reg[63:8]}; // arithmetic right shift by 8 bits
            end
        endcase
    end
end

assign q = q_reg;

endmodule