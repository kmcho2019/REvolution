module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    reg Y1_reg;  // Internal reg variable to hold the computed next state of y[1]

    // Next-state logic for y[1] using a case statement
    always @(y, w) begin
        case (y)
            3'b000: Y1_reg = ~w;  // A (0) --0--> B, A (0) --1--> A
            3'b001: Y1_reg = w;   // B (0) --0--> C, B (0) --1--> D
            3'b010: Y1_reg = w;   // C (0) --0--> E, C (0) --1--> D
            3'b011: Y1_reg = w;   // D (0) --0--> F, D (0) --1--> A
            3'b100: Y1_reg = w;   // E (1) --0--> E, E (1) --1--> D
            3'b101: Y1_reg = ~w;  // F (1) --0--> C, F (1) --1--> D
            default: Y1_reg = 1'b0;
        endcase
    end

    // Continuous assignment of Y1_reg to Y1
    assign Y1 = Y1_reg;
endmodule