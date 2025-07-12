module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg toggle_state = 0;

always @(posedge clk) begin
    if (a & b) begin
        toggle_state <= ~toggle_state;
    end
end

assign q = (a ^ b) ^ (toggle_state & (a | b));
assign state = toggle_state;

endmodule