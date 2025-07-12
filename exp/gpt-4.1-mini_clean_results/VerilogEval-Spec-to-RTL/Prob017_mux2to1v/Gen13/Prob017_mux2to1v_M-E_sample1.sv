module SmallMux2to1 #(
    parameter WIDTH = 10
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_chunks
            SmallMux2to1 #(.WIDTH(10)) mux_inst (
                .a   (a[i*10 +: 10]),
                .b   (b[i*10 +: 10]),
                .sel (sel),
                .out (out[i*10 +: 10])
            );
        end
    endgenerate
endmodule