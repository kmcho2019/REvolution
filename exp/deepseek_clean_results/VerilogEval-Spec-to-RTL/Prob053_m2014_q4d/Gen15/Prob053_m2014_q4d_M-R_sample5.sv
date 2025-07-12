module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire next_state = in ^ state;
    
    assign state = clk ? next_state : state;
    assign out = state;

endmodule