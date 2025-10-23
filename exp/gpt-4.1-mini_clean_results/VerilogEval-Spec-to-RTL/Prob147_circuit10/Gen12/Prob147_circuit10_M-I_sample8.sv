module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire set    = a & ~b;
wire reset  = ~a & b;
wire toggle = a & b;

wire next_state = toggle ? ~state : (set ? 1'b1 : (reset ? 1'b0 : state));

always @(posedge clk) begin
    state <= next_state;
end

assign q = toggle ? ~state : state;

initial state = 1'b0;

endmodule