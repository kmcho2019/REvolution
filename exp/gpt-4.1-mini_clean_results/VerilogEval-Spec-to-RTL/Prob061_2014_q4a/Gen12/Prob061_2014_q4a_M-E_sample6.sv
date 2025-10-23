module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    // Asynchronous load logic: when L is asserted, Q is set to R immediately
    always @(posedge clk or posedge L) begin
        if (L)
            Q <= R;
        else if (E)
            Q <= w;
    end

endmodule