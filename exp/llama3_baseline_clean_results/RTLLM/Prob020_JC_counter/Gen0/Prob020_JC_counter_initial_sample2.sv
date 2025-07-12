module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        Q <= 64'd0; // Reset counter value to 0
    end else begin
        if (Q[0] == 0) begin // Least significant bit is 0, increment counter
            Q <= {1, Q[63:1]}; // Shift current value to the right and append 1
        end else begin // Least significant bit is 1, decrement counter
            Q <= {0, Q[63:1]}; // Shift current value to the right and append 0
        end
    end
end

endmodule