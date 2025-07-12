module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

assign q = state;

always @(posedge clk) begin
    case ({a,b})
        2'b00: state <= state;    // hold
        2'b01: state <= 1'b1;     // set
        2'b10: state <= 1'b0;     // reset
        2'b11: state <= ~state;   // toggle
    endcase
end

initial state = 1'b0;

endmodule