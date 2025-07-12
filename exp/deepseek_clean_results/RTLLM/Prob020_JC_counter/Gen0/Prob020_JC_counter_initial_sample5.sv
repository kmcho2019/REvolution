module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset: initialize to all 0s
        Q <= 64'b0;
    end else begin
        // Johnson counter operation
        if (Q[0] == 1'b0) begin
            // Shift right and set MSB to 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Shift right and set MSB to 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule