module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] state;
    wire [511:0] next_state;
    
    // Calculate next state using vector operations
    // Left neighbor is {1'b0, state[511:1]} (shift right with 0 fill)
    // Right neighbor is {state[510:0], 1'b0} (shift left with 0 fill)
    assign next_state = {state[510:0], 1'b0} ^ {1'b0, state[511:1]};
    
    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment
    assign q = state;

endmodule