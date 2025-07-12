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
        Q <= R;
    end else if (E) begin
        Q <= w;
    end else begin
        // Directly keep the current state of Q when neither L nor E is asserted
        // This approach minimizes transitions and maintains simplicity
    end
end

endmodule