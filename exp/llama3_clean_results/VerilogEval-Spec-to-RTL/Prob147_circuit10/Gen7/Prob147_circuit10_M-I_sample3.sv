module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0; // Reset state to 0 when a=1, b=1
    end else if (a == 1'b0 && b == 1'b1) begin
        state <= 1'b1; // Set state to 1 when a=0, b=1
    end else begin
        state <= state; // Otherwise, retain current state
    end
    q <= state || (a && ~b); // Update q based on state and a, b
end

endmodule