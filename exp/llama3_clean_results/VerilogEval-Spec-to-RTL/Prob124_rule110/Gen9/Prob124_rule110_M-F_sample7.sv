module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    for (int i = 0; i < 512; i++) begin
        wire left, center, right;

        assign left = (i == 0) ? 1'b0 : current_state[i - 1];
        assign center = current_state[i];
        assign right = (i == 511) ? 1'b0 : current_state[i + 1];

        wire next_state_bit;
        assign next_state_bit = ~(left & center & right) & (~left | ~center | ~right);

        next_state[i] = next_state_bit;
    end
end

assign q = current_state;

endmodule