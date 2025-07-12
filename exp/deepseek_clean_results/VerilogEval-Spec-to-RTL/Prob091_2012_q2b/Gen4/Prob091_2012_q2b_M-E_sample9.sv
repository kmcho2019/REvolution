module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // LUT for Y1 (next state of y[1])
    wire [5:0] Y1_LUT = {
        1'b0,    // F (y[5]) -> never sets Y1
        1'b0,    // E (y[4]) -> never sets Y1
        1'b0,    // D (y[3]) -> never sets Y1
        w,       // C (y[2]) -> sets Y1 if w=1 (transition to F)
        w,       // B (y[1]) -> sets Y1 if w=1 (transition to C)
        w        // A (y[0]) -> sets Y1 if w=1 (transition to B)
    };

    // LUT for Y3 (next state of y[3])
    wire [5:0] Y3_LUT = {
        ~w,      // F (y[5]) -> sets Y3 if w=0 (transition to D)
        ~w,      // E (y[4]) -> sets Y3 if w=0 (transition to D)
        ~w,      // D (y[3]) -> sets Y3 if w=0 (transition to A)
        ~w,      // C (y[2]) -> sets Y3 if w=0 (transition to D)
        ~w,      // B (y[1]) -> sets Y3 if w=0 (transition to D)
        1'b0     // A (y[0]) -> never sets Y3
    };

    // Select the appropriate LUT output based on current state
    assign Y1 = |(y & Y1_LUT);
    assign Y3 = |(y & Y3_LUT);

endmodule