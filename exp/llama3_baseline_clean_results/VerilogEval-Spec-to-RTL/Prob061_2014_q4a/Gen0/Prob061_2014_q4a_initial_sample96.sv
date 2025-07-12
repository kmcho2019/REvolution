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
        Q <= R; // Load value from R when L is asserted
    end else if (E) begin
        Q <= w; // Shift in value from previous stage when E is asserted
    end else begin
        // Retain current value when neither L nor E is asserted
    end
end

endmodule