module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Johnson counter with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        // Johnson counter operation: shift right and invert LSB to MSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule