module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(*) begin
    // Combinational logic for output 'z' based on current state and input 'x'
    z = (state) ? ~x : x;
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        // Directly encode next state logic
        state <= (state && (x == 0 || x == 1)) || (!state && x == 1);
    end
end

endmodule