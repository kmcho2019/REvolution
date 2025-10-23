module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;            // Load has highest priority
        else if (E)
            Q <= w;            // Shift when enabled
        else
            Q <= Q;            // Hold current value to reduce toggling
    end

endmodule