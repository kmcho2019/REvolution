module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear reset initialization
        Q <= 64'b0;
    end else begin
        // Efficient Johnson counter operation
        // MSB is inverse of LSB, right shift the rest
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule