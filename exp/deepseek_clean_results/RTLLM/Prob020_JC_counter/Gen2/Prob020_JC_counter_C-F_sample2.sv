module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset: initialize to all zeros
        Q <= 64'b0;
    end
    else begin
        // Johnson counter operation:
        // Right shift and feedback inverted LSB to MSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule