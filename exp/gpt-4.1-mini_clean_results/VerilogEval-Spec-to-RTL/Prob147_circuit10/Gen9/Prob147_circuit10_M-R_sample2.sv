module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (a == 1'b0 && b == 1'b0) ? state :
                    (a == 1'b0 && b == 1'b1) ? 1'b1 :
                    (a == 1'b1 && b == 1'b0) ? 1'b0 :
                    ~state; // a=1, b=1 toggle

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0; // initialize state to 0 at simulation start
end

endmodule