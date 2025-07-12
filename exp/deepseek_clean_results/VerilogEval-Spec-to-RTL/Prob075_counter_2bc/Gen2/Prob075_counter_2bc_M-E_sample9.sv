module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else if (train_valid) begin
        if (train_taken) begin
            // Increment: XOR with mask, but don't overflow
            state <= {state[1] | (state[0] & ~state[1]), 
                     state[0] ^ (~state[1])};
        end else begin
            // Decrement: XOR with mask, but don't underflow
            state <= {state[1] & (state[0] | state[1]),
                     state[0] ^ (state[1] | state[0])};
        end
    end
end

endmodule