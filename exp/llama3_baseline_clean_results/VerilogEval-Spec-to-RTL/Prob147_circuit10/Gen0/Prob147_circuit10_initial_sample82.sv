module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg next_state;
reg curr_state;

always @(posedge clk) begin
    curr_state <= next_state;
end

always @(*) begin
    case ({a, b})
        2'b00: next_state = curr_state;
        2'b01: next_state = ~curr_state;
        2'b10: next_state = curr_state;
        2'b11: next_state = ~curr_state;
    endcase
    q = curr_state;
    state = curr_state;
end

endmodule