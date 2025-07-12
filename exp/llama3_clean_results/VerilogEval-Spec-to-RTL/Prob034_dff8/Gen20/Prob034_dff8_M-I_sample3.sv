// Improved TopModule with initialization and reset
module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input rst_n,  // Active low reset
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Generate WIDTH D flip-flops with reset
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        always_ff @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                q[i] <= 0;  // Reset to 0
            end else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule