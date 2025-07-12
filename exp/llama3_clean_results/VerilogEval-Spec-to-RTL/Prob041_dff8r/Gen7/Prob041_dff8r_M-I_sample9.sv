// D Flip-Flop module with synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 1'b0; // Active high synchronous reset
    end else begin
        q <= d; // Assign input to output on positive clock edge
    end
end

endmodule

// TopModule with 8 D Flip-Flops and clock gating (if applicable)
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Clock gating signal (if clock gating is applicable)
// logic clock_gated;

// For simplicity, assuming clock gating is not needed or already handled elsewhere
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_i(
            .clk(clk), // Directly use the input clock for simplicity
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule