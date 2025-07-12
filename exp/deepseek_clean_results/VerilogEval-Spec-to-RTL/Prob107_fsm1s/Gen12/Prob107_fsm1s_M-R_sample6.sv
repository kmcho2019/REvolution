module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding
    localparam [1:0] STATE_A = 2'b01;
    localparam [1:0] STATE_B = 2'b10;
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
            out <= 1'b1;
        end else begin
            // State transitions
            state[0] <= (~state[1] & ~in) | (state[0] & in);  // A state logic
            state[1] <= (state[1] & in) | (~state[0] & ~in);  // B state logic
            
            // Registered output
            out <= state[1];
        end
    end

endmodule