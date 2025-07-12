// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) Q <= 64'd0; // Reset condition
    else begin
        // Conditional update of Q based on its least significant bit
        if (Q[0] == 1'b0)
            Q <= {1'b1, Q[63:1]}; // Increment
        else
            Q <= {1'b0, Q[63:1]}; // Decrement
    end
end

endmodule