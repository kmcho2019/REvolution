module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // If the reset signal is low, reset the counter to 0
        Q <= 64'd0;
    end else begin
        // If the least significant bit is 0, increment the counter
        if (Q[0] == 1'b0) begin
            Q <= {1'b1, Q[63:1]};
        end
        // If the least significant bit is 1, decrement the counter
        else begin
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule