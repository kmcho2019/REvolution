module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// Terminal state detection (for potential clock gating)
// wire all_zeros = (Q == {WIDTH{1'b0}});
// wire all_ones = (Q == {WIDTH{1'b1}});

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Active-low reset clears all bits
    end
    else begin
        // Efficient Johnson counter operation:
        // Shift right and insert inverted LSB at MSB
        Q <= {~Q[0], Q[WIDTH-1:1]};
    end
end

endmodule