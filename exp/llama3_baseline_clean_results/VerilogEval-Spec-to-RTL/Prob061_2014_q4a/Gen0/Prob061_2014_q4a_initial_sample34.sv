module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load the value R when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift the value w when E is asserted and L is not
        Q <= w;
    end else begin
        // Hold the current value when neither L nor E is asserted
        Q <= Q;
    end
end

endmodule