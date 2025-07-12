module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output  reg [63:0] q
);
    wire msb = q[63];
    wire [63:0] arith_right_1, arith_right_8, left_1, left_8;
    
    // Shift left by 1: shift q left by 1 bit, LSB filled with 0
    assign left_1 = {q[62:0], 1'b0};
    // Shift left by 8: shift q left by 8 bits, lower 8 bits filled with 0
    assign left_8 = {q[55:0], 8'b0};
    
    // Arithmetic shift right by 1: shift q right by 1 bit, MSB filled with sign bit
    assign arith_right_1 = {msb, q[63:1]};
    // Arithmetic shift right by 8: shift q right by 8 bits, upper 8 bits filled with sign bit replicated
    assign arith_right_8 = {{8{msb}}, q[63:8]};
    
    // Choose shifted value based on amount
    // amount:
    // 00 - left shift by 1
    // 01 - left shift by 8
    // 10 - arithmetic right shift by 1
    // 11 - arithmetic right shift by 8
    wire [63:0] shifted;
    assign shifted = (amount == 2'b00) ? left_1 :
                     (amount == 2'b01) ? left_8 :
                     (amount == 2'b10) ? arith_right_1 :
                                         arith_right_8;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
    end
endmodule