module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Output Y1 is y[1]
    assign Y1 = y[1];

    // Next state logic for y[1] only
    // Using the state transition table:
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // For each (y,w), determine next state's y[1] bit

    // We'll implement a combinational function that outputs next_y1
    // based on current y and w

    wire next_y1;

    // Define states for clarity
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // Next state mapping from problem
    // Implement next_y1 = next state's bit 1

    // Using combinational logic with case statement
    reg next_y1_reg;
    always @(*) begin
        case (y)
            A: begin
                if (w == 1'b0)      // input w = 0: A->B (001), y[1]=0
                    next_y1_reg = 1'b0;
                else                // A->A (000), y[1]=0
                    next_y1_reg = 1'b0;
            end
            B: begin
                if (w == 1'b0)      // B->C (010), y[1]=1
                    next_y1_reg = 1'b1;
                else                // B->D (011), y[1]=1
                    next_y1_reg = 1'b1;
            end
            C: begin
                if (w == 1'b0)      // C->E (100), y[1]=0
                    next_y1_reg = 1'b0;
                else                // C->D (011), y[1]=1
                    next_y1_reg = 1'b1;
            end
            D: begin
                if (w == 1'b0)      // D->F (101), y[1]=0
                    next_y1_reg = 1'b0;
                else                // D->A (000), y[1]=0
                    next_y1_reg = 1'b0;
            end
            E: begin
                if (w == 1'b0)      // E->E (100), y[1]=0
                    next_y1_reg = 1'b0;
                else                // E->D (011), y[1]=1
                    next_y1_reg = 1'b1;
            end
            F: begin
                if (w == 1'b0)      // F->C (010), y[1]=1
                    next_y1_reg = 1'b1;
                else                // F->D (011), y[1]=1
                    next_y1_reg = 1'b1;
            end
            default: next_y1_reg = 1'b0;
        endcase
    end

    assign next_y1 = next_y1_reg;

endmodule