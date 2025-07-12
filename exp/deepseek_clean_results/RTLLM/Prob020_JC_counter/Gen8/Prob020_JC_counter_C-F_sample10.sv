module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Helps with timing closure

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        // Johnson counter operation:
        // Right shift with inverted LSB as new MSB
        // For timing: Consider pipelining if clock frequency > 500MHz
        // For power: Clock gating when counter reaches extremes (all 1s or 0s)
        // For area: Could use 6-bit counter + decoder (trades area for logic)
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule