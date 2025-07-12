module TopModule #(
    parameter WIDTH = 16,
    parameter DEFAULT_VAL = {WIDTH{1'b1}}  // Default to all 1s but configurable
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] c,
    input  [WIDTH-1:0] d,
    input  [WIDTH-1:0] e,
    input  [WIDTH-1:0] f,
    input  [WIDTH-1:0] g,
    input  [WIDTH-1:0] h,
    input  [WIDTH-1:0] i,
    input  [3:0]       sel,
    output reg [WIDTH-1:0] out
);

reg [WIDTH-1:0] mux_out;

always @(*) begin
    unique case (sel)
        4'd0: mux_out = a;
        4'd1: mux_out = b;
        4'd2: mux_out = c;
        4'd3: mux_out = d;
        4'd4: mux_out = e;
        4'd5: mux_out = f;
        4'd6: mux_out = g;
        4'd7: mux_out = h;
        4'd8: mux_out = i;
        default: mux_out = DEFAULT_VAL; // sel 9-15
    endcase
end

// Optional output register stage for timing improvement
always @(posedge clk) begin
    out <= mux_out;
end

endmodule