module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as parameters for better readability and maintainability
parameter B = 1'b1;
parameter A = 1'b0;

// State register
reg state;

// Output assignment based on current state
assign out = (state == B); // Out is 1 in state B and 0 in state A

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        // Synchronous reset to state B
        state <= B;
    end else begin
        // State transitions based on current state and input
        state <= (state == B) ? (in ? B : A) : (in ? A : B);
    end
end

endmodule