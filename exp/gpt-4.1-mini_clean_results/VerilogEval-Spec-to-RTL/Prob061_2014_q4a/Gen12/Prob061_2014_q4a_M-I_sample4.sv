module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)         // Load has highest priority
            Q <= R;
        else if (E)    // Shift if enabled and no load
            Q <= w;
        // no else needed - register retains its value naturally
    end

endmodule