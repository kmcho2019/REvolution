module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

// Compute next state combinationally based on J, K, and current Q
assign nextQ = (j & ~k)       ? 1'b1  :  // Set
               (~j & k)       ? 1'b0  :  // Reset
               (j & k)        ? ~Q    :  // Toggle
                                Q;     // Hold

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule