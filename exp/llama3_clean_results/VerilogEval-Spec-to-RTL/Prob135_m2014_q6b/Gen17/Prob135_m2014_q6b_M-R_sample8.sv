module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    assign Y1 = 
        (y == STATE_A && w) || 
        (y == STATE_B && w) || 
        (y == STATE_D) || 
        (y == STATE_E && ~w) || 
        (y == STATE_F && ~w);

endmodule