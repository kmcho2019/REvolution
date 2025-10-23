module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] lfsr_state;
reg feedback;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        lfsr_state <= 64'd0; // Reset the LFSR state to 0 when rst_n is low
    end else begin
        // Determine the feedback bit based on the least significant bit of the current state
        if (lfsr_state[0] == 1'b0) begin
            feedback <= 1'b1; // Append 1 if the least significant bit is 0
        end else begin
            feedback <= 1'b0; // Append 0 if the least significant bit is 1
        end
        
        // Update the LFSR state by shifting and appending the feedback bit
        lfsr_state <= {feedback, lfsr_state[63:1]};
        
        // Assign the updated LFSR state to the output Q
        Q <= lfsr_state;
    end
end

endmodule