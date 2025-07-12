module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Define a 2:1 multiplexer to select between w and Q
always @(posedge clk) begin
    if (L) begin
        // Load R into Q
        Q <= R;
    end else if (E) begin
        // Shift w into Q
        Q <= w;
    end else begin
        // Retain current value of Q
        Q <= Q;
    end
end

endmodule