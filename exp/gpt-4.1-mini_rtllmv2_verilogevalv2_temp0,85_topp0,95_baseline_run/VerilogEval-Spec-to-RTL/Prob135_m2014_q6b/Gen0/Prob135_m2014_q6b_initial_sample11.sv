module TopModule (
    input  wire [2:0] y,  // current state
    input  wire       w,
    output wire       Y1
);

    // Implement next-state logic for y[1] based on current y and w
    // State codes: A=000, B=001, C=010, D=011, E=100, F=101
    // Extract current state bits for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: begin // A
                if (w == 1'b0)
                    next_y1 = 1'b0; // next state B=001 -> y[1]=0
                else
                    next_y1 = 1'b0; // next state A=000 -> y[1]=0
            end
            3'b001: begin // B
                if (w == 1'b0)
                    next_y1 = 1'b1; // next state C=010 -> y[1]=1
                else
                    next_y1 = 1'b1; // next state D=011 -> y[1]=1
            end
            3'b010: begin // C
                if (w == 1'b0)
                    next_y1 = 1'b0; // next state E=100 -> y[1]=0
                else
                    next_y1 = 1'b1; // next state D=011 -> y[1]=1
            end
            3'b011: begin // D
                if (w == 1'b0)
                    next_y1 = 1'b0; // next state F=101 -> y[1]=0
                else
                    next_y1 = 1'b0; // next state A=000 -> y[1]=0
            end
            3'b100: begin // E
                if (w == 1'b0)
                    next_y1 = 1'b0; // next state E=100 -> y[1]=0
                else
                    next_y1 = 1'b1; // next state D=011 -> y[1]=1
            end
            3'b101: begin // F
                if (w == 1'b0)
                    next_y1 = 1'b0; // next state C=010 -> y[1]=0
                else
                    next_y1 = 1'b1; // next state D=011 -> y[1]=1
            end
            default: next_y1 = y1; // default hold state
        endcase
    end

    assign Y1 = y1; // output is current y[1]

endmodule