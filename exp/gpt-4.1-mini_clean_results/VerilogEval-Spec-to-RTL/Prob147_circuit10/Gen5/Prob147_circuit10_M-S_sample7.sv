module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (a & b) ? ~state :    // toggle when a=1,b=1
                    (~a & b) ? 1'b1 :    // set when a=0,b=1
                    (a & ~b) ? 1'b0 :    // reset when a=1,b=0
                    state;               // hold when a=0,b=0

assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule