module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (b == 0) begin
        // When b=0, state tends to hold or clear based on 'a' and current state
        if (state == 1 && a == 0)
            next_state = 1;
        else
            next_state = 0;
    end else begin
        // When b=1, next_state toggles based on a
        if (a == 1)
            next_state = ~state;
        else
            next_state = 0;
    end
end

always @(posedge clk) begin
    state <= next_state;
end

// Output q is combinational from current inputs and current state
assign q = (state & b) | (a & ~b);

endmodule