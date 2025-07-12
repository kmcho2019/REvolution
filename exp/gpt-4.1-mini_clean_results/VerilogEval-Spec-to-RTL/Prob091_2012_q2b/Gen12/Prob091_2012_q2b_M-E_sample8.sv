module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // State bit indices for clarity
    localparam A = 0;
    localparam B = 1;
    localparam C = 2;
    localparam D = 3;
    localparam E = 4;
    localparam F = 5;

    // Local function returning next input for Y1 (state B flip-flop)
    function next_Y1;
        input [5:0] curr_y;
        input       w_in;
        begin
            // Transitions into B:
            // A --1--> B
            next_Y1 = curr_y[A] & w_in;
        end
    endfunction

    // Local function returning next input for Y3 (state D flip-flop)
    function next_Y3;
        input [5:0] curr_y;
        input       w_in;
        begin
            // Transitions into D:
            // B(0) --0--> D
            // C(0) --0--> D
            // E(1) --0--> D
            // F(1) --0--> D
            next_Y3 = (~w_in) & (curr_y[B] | curr_y[C] | curr_y[E] | curr_y[F]);
        end
    endfunction

    assign Y1 = next_Y1(y, w);
    assign Y3 = next_Y3(y, w);

endmodule