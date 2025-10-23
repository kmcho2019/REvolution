module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State transition matrix decoder for Y1 (B state)
    wire A_to_B = y[0] & w;          // A --1--> B
    wire B_to_C = y[1] & w;          // B --1--> C
    wire C_to_E = y[2] & w;          // C --1--> E
    wire D_to_F = y[3] & w;          // D --1--> F
    wire F_to_C = y[5] & w;          // F --1--> C
    
    // State transition matrix decoder for Y3 (D state)
    wire B_to_D = y[1] & ~w;         // B --0--> D
    wire C_to_D = y[2] & ~w;         // C --0--> D
    wire D_to_A = y[3] & ~w;         // D --0--> A
    wire E_to_D = y[4] & ~w;         // E --0--> D
    wire F_to_D = y[5] & ~w;         // F --0--> D

    // Next state logic
    assign Y1 = A_to_B;              // Only A can transition to B
    assign Y3 = B_to_D | C_to_D | E_to_D | F_to_D;  // Multiple states can transition to D

endmodule