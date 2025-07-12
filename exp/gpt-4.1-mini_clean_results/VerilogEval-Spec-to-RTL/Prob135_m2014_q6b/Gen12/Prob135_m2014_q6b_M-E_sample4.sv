module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);
    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: begin // A
                if (w == 1'b0) next_y1 = 1'b0; // next B=001 (y[1]=0)
                else           next_y1 = 1'b0; // next A=000 (y[1]=0)
            end
            3'b001: begin // B
                if (w == 1'b0) next_y1 = 1'b1; // next C=010 (y[1]=1)
                else           next_y1 = 1'b1; // next D=011 (y[1]=1)
            end
            3'b010: begin // C
                if (w == 1'b0) next_y1 = 1'b0; // next E=100 (y[1]=0)
                else           next_y1 = 1'b1; // next D=011 (y[1]=1)
            end
            3'b011: begin // D
                if (w == 1'b0) next_y1 = 1'b1; // next F=101 (y[1]=1)
                else           next_y1 = 1'b0; // next A=000 (y[1]=0)
            end
            3'b100: begin // E
                if (w == 1'b0) next_y1 = 1'b0; // next E=100 (y[1]=0)
                else           next_y1 = 1'b1; // next D=011 (y[1]=1)
            end
            3'b101: begin // F
                if (w == 1'b0) next_y1 = 1'b1; // next C=010 (y[1]=1)
                else           next_y1 = 1'b1; // next D=011 (y[1]=1)
            end
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule