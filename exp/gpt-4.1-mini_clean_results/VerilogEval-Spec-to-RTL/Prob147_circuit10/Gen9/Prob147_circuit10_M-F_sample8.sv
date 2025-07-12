module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (b == 1'b1) ? 
                    ((a == 1'b0) ? ~state : 1'b0) : // toggle if a=0,b=1; reset if a=1,b=1
                    state;                          // hold if b=0

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule