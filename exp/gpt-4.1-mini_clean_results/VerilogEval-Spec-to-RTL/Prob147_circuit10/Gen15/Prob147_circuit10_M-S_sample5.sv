module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (a == 0 && b == 1) ? 1'b1 :
                    (a == 1 && b == 1) ? 1'b0 :
                    (a == 1 && b == 0) ? ~state :
                                         state;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial state = 1'b0;

endmodule