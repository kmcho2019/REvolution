module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    // Sequential logic with embedded priority mux:
    // On posedge clk: if load asserted, load R; else if enable asserted, shift in w; else hold Q implicitly.
    always_ff @(posedge clk) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end
        // else: hold Q implicitly (no assignment needed)
    end

endmodule