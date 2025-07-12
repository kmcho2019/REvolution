module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // 1 means we've seen the first '1' and are in "add 1" phase
reg [1:0] temp; // Temporary variable for demonstration; actual implementation might not need this

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset state
    end else if (~state && x) begin // Transition to "add 1" phase
        state <= 1'b1;
    end
end

always @(posedge clk) begin
    if (state) begin // If we're in "add 1" phase, output is simply the inversion of input
        z <= ~x;
    end else begin // If we're still inverting all bits
        z <= ~x;
    end
end

endmodule