module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Set Q to all zeros
        Q <= 64'd0;
    end else begin
        // Normal operation
        if (Q[0] == 1'b0) begin
            // Increment: Shift right and append 1 as MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Decrement: Shift right and append 0 as MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule