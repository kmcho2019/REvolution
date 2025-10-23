module TopModule (
    input  wire [2:0] y,  // current state bits y[2], y[1], y[0]
    input  wire       w,  // input
    output wire       Y1   // output equals current y[1]
);

    // next_y1: combinational next state bit y[1]
    reg next_y1;

    always @* begin
        case (y)
            3'b000: begin // A: transitions A(000) or B(001)
                // w=0 -> B=001 y1=0, w=1-> A=000 y1=0
                next_y1 = 1'b0;
            end
            3'b001: begin // B: transitions C(010) or D(011)
                // C=010 y1=1, D=011 y1=1
                next_y1 = 1'b1;
            end
            3'b010: begin // C: transitions E(100) or D(011)
                // E=100 y1=0, D=011 y1=1
                next_y1 = w ? 1'b1 : 1'b0;
            end
            3'b011: begin // D: transitions F(101) or A(000)
                // F=101 y1=0, A=000 y1=0
                next_y1 = 1'b0;
            end
            3'b100: begin // E: transitions E(100) or D(011)
                // E=100 y1=0, D=011 y1=1
                next_y1 = w ? 1'b1 : 1'b0;
            end
            3'b101: begin // F: transitions C(010) or D(011)
                // C=010 y1=1, D=011 y1=1
                next_y1 = 1'b1;
            end
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule