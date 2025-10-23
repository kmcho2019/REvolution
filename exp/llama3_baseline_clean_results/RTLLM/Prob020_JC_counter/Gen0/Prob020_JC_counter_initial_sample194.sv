module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter to 0 on negative edge of rst_n
        Q <= 64'd0;
    end else begin
        // Update counter on positive edge of clk
        if (Q[0] == 1'b0) begin
            // Increment: shift right and set MSB to 1
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: shift right and set MSB to 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule