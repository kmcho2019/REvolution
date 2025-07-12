module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, set the counter to 0
        Q <= 64'd0;
    end else begin
        // Update counter based on the LSB's value
        if (Q[0] == 1'b0) begin
            // If LSB is 0, append 1 at MSB and shift right
            Q <= {1'b1, Q[63:1]};
        end else begin
            // If LSB is 1, append 0 at MSB and shift right
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule