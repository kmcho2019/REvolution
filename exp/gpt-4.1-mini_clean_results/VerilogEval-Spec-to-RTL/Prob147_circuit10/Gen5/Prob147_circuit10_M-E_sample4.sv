module TopModule(
    input        clk,
    input        a,
    input        b,
    output reg   state,
    output       q
);

wire next_state;

assign next_state = (a & b)   ? ~state :   // toggle
                    (~a & b)  ? 1'b1 :    // set
                    (~a & ~b) ? 1'b0 :    // reset
                                state;     // hold (a=1,b=0)

// Output logic
assign q = (~state & ~a & b) | (state & ~b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule