module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L)          // Load has highest priority
            Q <= R;
        else if (E)     // Shift enable active
            Q <= w;
        else            // Hold current value
            Q <= Q;
    end

endmodule