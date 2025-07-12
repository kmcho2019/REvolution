module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Implement as a 3-level multiplexer tree
    wire [1:0] stage1_0 = in[1] ? (in[0] ? 2'b11 : 2'b10) : (in[0] ? 2'b01 : 2'b00);
    wire [1:0] stage1_1 = in[1] ? (in[0] ? 2'b10 : 2'b01) : (in[0] ? 2'b00 : 2'b00);
    
    assign out = in[2] ? stage1_0 : stage1_1;

endmodule