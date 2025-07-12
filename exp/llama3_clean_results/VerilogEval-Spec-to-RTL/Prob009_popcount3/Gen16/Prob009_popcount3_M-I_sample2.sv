module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Using a more optimized combinational logic approach
    assign out = (in[0] == 1'b1) + (in[1] == 1'b1) + (in[2] == 1'b1);

    // Alternatively, using Verilog's conditional operator
    // assign out = ({in[0], in[1], in[2]} == 3'b001) ? 2'd1 :
    //               ({in[0], in[1], in[2]} == 3'b010) ? 2'd1 :
    //               ({in[0], in[1], in[2]} == 3'b011) ? 2'd2 :
    //               ({in[0], in[1], in[2]} == 3'b100) ? 2'd1 :
    //               ({in[0], in[1], in[2]} == 3'b101) ? 2'd2 :
    //               ({in[0], in[1], in[2]} == 3'b110) ? 2'd2 :
    //               ({in[0], in[1], in[2]} == 3'b111) ? 2'd3 : 2'd0;

endmodule