module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= R;     // Load operation has highest priority
        else if (E)
            Q <= w;     // Shift operation if enabled
        // else no assignment needed, hold current value
    end

endmodule