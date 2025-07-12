module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (b == 1'b1) ? 
                        ((a == 1'b0) ? 1'b1 : 1'b0) :  // if b=1,a=0 set; if b=1,a=1 reset
                   (a == 1'b1) ? 1'b0 :             // if b=0,a=1 reset
                                 ~state;               // if b=0,a=0 toggle

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule