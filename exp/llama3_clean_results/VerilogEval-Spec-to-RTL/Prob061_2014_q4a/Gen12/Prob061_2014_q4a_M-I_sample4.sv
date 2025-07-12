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
        Q <= R; // Load value R into Q when L is asserted
    end else if (E) begin
        Q <= w; // Shift in value w when E is asserted
    end else begin
        Q <= Q; // Explicitly retain Q's value when neither L nor E is asserted
    end
end

endmodule