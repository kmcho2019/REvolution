module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (~a & b)             ? 1'b1  :  // set
                    (a & b)              ? 1'b0  :  // reset
                    (a & ~b)             ? ~state :  // toggle
                                          state;   // hold

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial state = 1'b0;

endmodule