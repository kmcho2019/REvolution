module TopModule (
    input  [5:0] y,   // one-hot current state
    input        w,   // input
    output reg   Y1,  // next-state input for y[1] (state B)
    output reg   Y3   // next-state input for y[3] (state D)
);

    // Combinational logic for Y1 and Y3
    always @(*) begin
        // Defaults
        Y1 = 1'b0;
        Y3 = 1'b0;

        casez (y)
            6'b000001: begin // state A (y[0])
                // A --1--> B, else stays A
                Y1 = w;       // y[0] & w => just w since y[0] active
                // No transition to D from A, so Y3 = 0
            end
            6'b000010: begin // state B (y[1])
                // B --0--> D
                Y3 = ~w;
                // No next state B transition here => Y1=0
            end
            6'b000100: begin // state C (y[2])
                // C --0--> D
                Y3 = ~w;
                // No next state B transition => Y1=0
            end
            6'b001000: begin // state D (y[3])
                // D --0--> A (not B or D)
                // D --1--> F (not B or D)
                // So Y1=0, Y3=0
                // No transitions lead to B or D as next states here
            end
            6'b010000: begin // state E (y[4])
                // E --0--> D
                Y3 = ~w;
                // E --1--> E (no B or D)
                // So only Y3 updated
            end
            6'b100000: begin // state F (y[5])
                // F --0--> D
                Y3 = ~w;
                // F --1--> C (not B or D)
                // So only Y3 updated
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule