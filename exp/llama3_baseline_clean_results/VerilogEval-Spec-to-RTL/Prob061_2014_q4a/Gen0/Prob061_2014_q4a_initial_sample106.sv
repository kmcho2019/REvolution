module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        // Load R into the DFF when L is asserted
        Q <= R;
    end else if (E) begin
        // Shift the value w from the previous stage into the DFF when E is asserted
        Q <= w;
    end
end

endmodule