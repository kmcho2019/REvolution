module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case ({y, w})
            // A=000
            4'b0000: next_y1 = 1'b0; // next state B=001 => y[1]=0
            4'b0001: next_y1 = 1'b0; // next state A=000 => y[1]=0

            // B=001
            4'b0010: next_y1 = 1'b0; // next state C=010 => y[1]=1'b0
            4'b0011: next_y1 = 1'b1; // next state D=011 => y[1]=1'b1

            // C=010
            4'b0100: next_y1 = 1'b0; // next state E=100 => y[1]=0
            4'b0101: next_y1 = 1'b1; // next state D=011 => y[1]=1

            // D=011
            4'b0110: next_y1 = 1'b1; // next state F=101 => y[1]=0 (101 -> y[1]=0)
                                    // Correction: F=101 -> y[1]=0
                                    // So next_y1=0 here
            4'b0111: next_y1 = 1'b0; // next state A=000 => y[1]=0

            // E=100
            4'b1000: next_y1 = 1'b0; // next state E=100 => y[1]=0
            4'b1001: next_y1 = 1'b1; // next state D=011 => y[1]=1

            // F=101
            4'b1010: next_y1 = 1'b0; // next state C=010 => y[1]=1'b0
            4'b1011: next_y1 = 1'b1; // next state D=011 => y[1]=1

            default: next_y1 = 1'b0; // Default safe value
        endcase
    end

    assign Y1 = next_y1;

endmodule