module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic as inferred from waveform:
assign next_state = (~a & b) ? 1'b1 :
                    (a & b) ? ~state :
                    1'b0;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule