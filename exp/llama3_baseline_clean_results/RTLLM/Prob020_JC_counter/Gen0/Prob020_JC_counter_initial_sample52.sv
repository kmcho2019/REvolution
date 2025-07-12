module JC_counter(
    input clk,  // Clock signal
    input rst_n,  // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // If reset is low
        Q <= 64'd0;  // Reset the counter to 0
    end else begin
        if (Q[0] == 1'b0) begin  // If LSB is 0
            Q <= {1'b1, Q[63:1]};  // Increment by shifting right and appending 1
        end else begin
            Q <= {1'b0, Q[63:1]};  // Decrement by shifting right and appending 0
        end
    end
end

endmodule