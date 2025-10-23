module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // Single flip-flop to represent the state

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        state <= x ? ~state : state; // Toggle state based on input x
    end
end

always @(*) begin
    z = state ? ~x : x; // Derive output z based on current state and input x
end

endmodule