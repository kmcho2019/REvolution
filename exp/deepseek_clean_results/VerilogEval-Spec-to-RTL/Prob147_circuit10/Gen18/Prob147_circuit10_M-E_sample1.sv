module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg current_state = 1'b0;
wire next_state;
wire xor_ab = a ^ b;
wire xnor_ab = ~xor_ab;

// State transition logic
assign next_state = (current_state == 1'b0) ? 
                   (a & b) :  // Set state when a AND b are both 1
                   (~(a | b)); // Reset state when both inputs are 0

// Output logic
assign q = (current_state == 1'b0) ? xor_ab : xnor_ab;

// State update on clock edge
always @(posedge clk) begin
    current_state <= next_state;
end

assign state = current_state;

endmodule