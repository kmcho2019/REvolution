module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

// On reset, clear Q to zero.
// Otherwise, shift right by 1 bit.
// MSB receives inverted LSB to implement Johnson counter behavior.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Serial shift register update:
        // MSB <= ~LSB
        // bits [62:0] <= bits [63:1]
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule