module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Define next_state combinationally:
assign next_state = (a & b) ? ~state :
                    (~a & b) ? 1'b1 :
                    1'b0;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 0;
end

endmodule