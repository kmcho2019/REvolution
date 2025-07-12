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
        // Efficient Johnson counter operation:
        // Shift right with inverted LSB as new MSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule