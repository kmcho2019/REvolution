module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

wire next_state;

assign next_state = (a & b) ? ~state :
                    (b & ~a) ? 1'b1 :
                    1'b0;

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
end

endmodule