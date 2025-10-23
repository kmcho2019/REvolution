module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    wire w_bar = ~w;
    wire state_A_or_D = y[0] | y[3];
    
    assign Y1 = y[0] & w;
    assign Y3 = w_bar & ~state_A_or_D;

endmodule