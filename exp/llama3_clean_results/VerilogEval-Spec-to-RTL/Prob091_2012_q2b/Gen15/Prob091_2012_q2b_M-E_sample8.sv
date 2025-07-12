module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Define the state transition matrix
    reg [5:0] nextStateMatrix [6][2];

    // Initialize the state transition matrix
    initial begin
        // A (0) --1--> B
        // A (0) --0--> A
        nextStateMatrix[0][0] = 6'b000001; // Next state for A when w is 0
        nextStateMatrix[0][1] = 6'b000010; // Next state for A when w is 1

        // B (1) --1--> C
        // B (1) --0--> D
        nextStateMatrix[1][0] = 6'b001000; // Next state for B when w is 0
        nextStateMatrix[1][1] = 6'b000100; // Next state for B when w is 1

        // C (2) --1--> E
        // C (2) --0--> D
        nextStateMatrix[2][0] = 6'b001000; // Next state for C when w is 0
        nextStateMatrix[2][1] = 6'b010000; // Next state for C when w is 1

        // D (3) --1--> F
        // D (3) --0--> A
        nextStateMatrix[3][0] = 6'b000001; // Next state for D when w is 0
        nextStateMatrix[3][1] = 6'b100000; // Next state for D when w is 1

        // E (4) --1--> E
        // E (4) --0--> D
        nextStateMatrix[4][0] = 6'b001000; // Next state for E when w is 0
        nextStateMatrix[4][1] = 6'b010000; // Next state for E when w is 1

        // F (5) --1--> C
        // F (5) --0--> D
        nextStateMatrix[5][0] = 6'b001000; // Next state for F when w is 0
        nextStateMatrix[5][1] = 6'b000100; // Next state for F when w is 1
    end

    // Generate the next-state values for Y1 and Y3
    always @(*) begin
        case (y)
            6'b000001: begin // State A
                if (w) begin
                    Y1 = nextStateMatrix[0][1][1]; // Next state for A when w is 1
                    Y3 = nextStateMatrix[0][1][3];
                end else begin
                    Y1 = nextStateMatrix[0][0][1]; // Next state for A when w is 0
                    Y3 = nextStateMatrix[0][0][3];
                end
            end
            6'b000010: begin // State B
                if (w) begin
                    Y1 = nextStateMatrix[1][1][1]; // Next state for B when w is 1
                    Y3 = nextStateMatrix[1][1][3];
                end else begin
                    Y1 = nextStateMatrix[1][0][1]; // Next state for B when w is 0
                    Y3 = nextStateMatrix[1][0][3];
                end
            end
            6'b000100: begin // State C
                if (w) begin
                    Y1 = nextStateMatrix[2][1][1]; // Next state for C when w is 1
                    Y3 = nextStateMatrix[2][1][3];
                end else begin
                    Y1 = nextStateMatrix[2][0][1]; // Next state for C when w is 0
                    Y3 = nextStateMatrix[2][0][3];
                end
            end
            6'b001000: begin // State D
                if (w) begin
                    Y1 = nextStateMatrix[3][1][1]; // Next state for D when w is 1
                    Y3 = nextStateMatrix[3][1][3];
                end else begin
                    Y1 = nextStateMatrix[3][0][1]; // Next state for D when w is 0
                    Y3 = nextStateMatrix[3][0][3];
                end
            end
            6'b010000: begin // State E
                if (w) begin
                    Y1 = nextStateMatrix[4][1][1]; // Next state for E when w is 1
                    Y3 = nextStateMatrix[4][1][3];
                end else begin
                    Y1 = nextStateMatrix[4][0][1]; // Next state for E when w is 0
                    Y3 = nextStateMatrix[4][0][3];
                end
            end
            6'b100000: begin // State F
                if (w) begin
                    Y1 = nextStateMatrix[5][1][1]; // Next state for F when w is 1
                    Y3 = nextStateMatrix[5][1][3];
                end else begin
                    Y1 = nextStateMatrix[5][0][1]; // Next state for F when w is 0
                    Y3 = nextStateMatrix[5][0][3];
                end
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule