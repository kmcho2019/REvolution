module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input resetn,
    input enable,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (!resetn) begin
            q <= {WIDTH{1'b0}};
        end else if (enable) begin
            q <= d;
        end
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
            DFF #(.WIDTH(1)) dff_inst (
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