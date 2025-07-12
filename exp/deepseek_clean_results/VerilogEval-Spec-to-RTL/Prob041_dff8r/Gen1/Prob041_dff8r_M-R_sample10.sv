module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Individual flip-flop storage
reg [7:0] q_ff;

// Generate 8 D flip-flops
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge clk) begin
            if (reset) begin
                q_ff[i] <= 1'b0;
            end else begin
                q_ff[i] <= d[i];
            end
        end
    end
endgenerate

// Continuous assignment for output
assign q = q_ff;

endmodule