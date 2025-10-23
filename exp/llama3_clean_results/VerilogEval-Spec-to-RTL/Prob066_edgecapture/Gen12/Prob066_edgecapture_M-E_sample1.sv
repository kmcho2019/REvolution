module TransitionDetector(
    input  clk,
    input  reset,
    input  in_bit,
    output out_bit
);

reg state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;
    end else if (in_bit == 1'b0 && state == 1'b0) begin
        // No change needed
    end else if (in_bit == 1'b0 && state == 1'b1) begin
        // No change needed
    end else if (in_bit == 1'b1 && state == 1'b0) begin
        // Previous state was 0, new state is 1, set to 1 if next state is 0
        state <= 1'b1;
    end else if (in_bit == 1'b1 && state == 1'b1) begin
        // Previous state was 1, new state is 1, no change needed
    end
end

assign out_bit = state;

endmodule

module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output [31:0] out
);

genvar i;
generate
    for (i = 0; i < 32; i++) begin
        TransitionDetector detector(
            .clk(clk),
            .reset(reset),
            .in_bit(in[i]),
            .out_bit(out[i])
        );
    end
endgenerate

endmodule