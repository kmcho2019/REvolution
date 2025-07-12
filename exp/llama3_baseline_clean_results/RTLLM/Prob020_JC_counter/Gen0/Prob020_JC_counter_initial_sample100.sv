module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        Q <= 64'd0; // Reset the counter to 0
    end else begin
        if (Q[0] == 1'b0) begin // If the least significant bit is 0, increment
            Q <= {1'b1, Q[63:1]}; // Shift right and append a 1 at the most significant bit
        end else begin // If the least significant bit is 1, decrement
            Q <= {1'b0, Q[63:1]}; // Shift right and append a 0 at the most significant bit
        end
    end
end

endmodule