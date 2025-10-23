module BitRegister (
    input clk,
    input resetn,
    input enable,
    input d,
    output reg q
);
    wire next_q = !resetn ? 1'b0 : enable ? d : q;

    always @(posedge clk) begin
        q <= next_q;
    end
endmodule

module ByteRegister #(
    parameter WIDTH = 8
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_gen
            BitRegister bit_reg (
                .clk(clk),
                .resetn(resetn),
                .enable(enable),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Instantiate two byte registers with individual enables
    ByteRegister upper_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[1]),
        .d(d[15:8]),
        .q(q[15:8])
    );

    ByteRegister lower_byte (
        .clk(clk),
        .resetn(resetn),
        .enable(byteena[0]),
        .d(d[7:0]),
        .q(q[7:0])
    );

endmodule