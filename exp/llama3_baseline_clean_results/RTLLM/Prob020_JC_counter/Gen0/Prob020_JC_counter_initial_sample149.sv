module JC_counter(
    input           clk,        // Clock signal
    input           rst_n,      // Active-low reset signal
    output reg [63:0] Q          // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // If reset signal is low, reset the counter to 0
        Q <= 64'd0;
    end else begin
        if (Q[0] == 1'b0) begin
            // If the least significant bit is 0, increment by shifting right and appending 1 at MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If the least significant bit is 1, decrement by shifting right and appending 0 at MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule