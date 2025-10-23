module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= q;
    end
end

wire [511:0] next_state;
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        assign left = (i == 0) ? 1'b0 : current_state[i - 1];
        assign center = current_state[i];
        assign right = (i == 511) ? 1'b0 : current_state[i + 1];

        assign next_state[i] = (
            (left == 1'b1 && center == 1'b1 && right == 1'b1) ? 1'b0 :
            (left == 1'b1 && center == 1'b1 && right == 1'b0) ? 1'b1 :
            (left == 1'b1 && center == 1'b0 && right == 1'b1) ? 1'b1 :
            (left == 1'b1 && center == 1'b0 && right == 1'b0) ? 1'b0 :
            (left == 1'b0 && center == 1'b1 && right == 1'b1) ? 1'b1 :
            (left == 1'b0 && center == 1'b1 && right == 1'b0) ? 1'b1 :
            (left == 1'b0 && center == 1'b0 && right == 1'b1) ? 1'b1 :
            (left == 1'b0 && center == 1'b0 && right == 1'b0) ? 1'b0 : 1'b0
        );
    end
endgenerate

assign q = next_state;

endmodule