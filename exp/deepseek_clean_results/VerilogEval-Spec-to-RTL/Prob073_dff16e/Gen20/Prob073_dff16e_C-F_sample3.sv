module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    // Clear next-state logic with reset and enable control
    wire [WIDTH-1:0] next_q = !resetn ? {WIDTH{1'b0}} :
                             enable ? d : q;

    always @(posedge clk) begin
        q <= next_q;
    end
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Instantiate parameterized byte registers with explicit width
    ByteRegister #(.WIDTH(8)) upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    ByteRegister #(.WIDTH(8)) lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule