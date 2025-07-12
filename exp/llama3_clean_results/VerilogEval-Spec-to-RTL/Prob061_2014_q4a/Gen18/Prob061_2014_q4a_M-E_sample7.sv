module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Sequential logic to update Q directly based on conditions
always @(posedge clk) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end else begin
        Q <= Q; // Hold the current value if neither condition is met
    end
end

endmodule