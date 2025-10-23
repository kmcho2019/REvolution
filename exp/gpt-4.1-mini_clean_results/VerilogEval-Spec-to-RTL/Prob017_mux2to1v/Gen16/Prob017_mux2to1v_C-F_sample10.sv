module SmallMux2to1 #(
    parameter WIDTH = 20
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
        for (i = 0; i < 5; i = i + 1) begin : mux_chunks_20bit
            SmallMux2to1 #(.WIDTH(20)) mux_inst (
                .a   (a[i*20 +: 20]),
                .b   (b[i*20 +: 20]),
                .sel (sel),
                .out (out[i*20 +: 20])
            );
        end
    endgenerate
endmodule