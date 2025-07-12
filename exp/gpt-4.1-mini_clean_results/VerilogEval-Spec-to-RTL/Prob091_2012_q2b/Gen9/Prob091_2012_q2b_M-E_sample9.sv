module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);
    always @(*) begin
        // Default output values
        Y1 = 1'b0;
        Y3 = 1'b0;

        case (1'b1) // One-hot state encoding: match the active bit
            y[0]: begin // State A
                // A --1--> B (y[1])
                // A --0--> A (no change to Y1 or Y3)
                if (w) 
                    Y1 = 1'b1;
            end
            y[1]: begin // State B
                // B --1--> C (y[2])
                // B --0--> D (y[3])
                if (~w)
                    Y3 = 1'b1;
            end
            y[2]: begin // State C
                // C --1--> E (y[4])
                // C --0--> D (y[3])
                if (~w)
                    Y3 = 1'b1;
            end
            y[3]: begin // State D
                // D --1--> F (y[5])
                // D --0--> A (y[0]) - not related to Y1 or Y3
                // Neither transition goes to B or D states explicitly next, so Y1 and Y3 remain 0
            end
            y[4]: begin // State E
                // E --1--> E (self)
                // E --0--> D (y[3])
                if (~w)
                    Y3 = 1'b1;
            end
            y[5]: begin // State F
                // F --1--> C (y[2])
                // F --0--> D (y[3])
                if (~w)
                    Y3 = 1'b1;
            end
            default: begin
                // No state active, all outputs zero
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end
endmodule