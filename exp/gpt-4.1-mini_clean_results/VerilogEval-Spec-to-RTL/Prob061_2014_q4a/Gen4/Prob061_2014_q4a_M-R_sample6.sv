module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    reg d;

    always @(*) begin
        if (L)
            d = R;   // Load data has highest priority
        else if (E)
            d = w;   // Shift data if enabled and not loading
        else
            d = Q;   // Retain current value if neither load nor shift
    end

    always @(posedge clk) begin
        Q <= d;
    end

endmodule