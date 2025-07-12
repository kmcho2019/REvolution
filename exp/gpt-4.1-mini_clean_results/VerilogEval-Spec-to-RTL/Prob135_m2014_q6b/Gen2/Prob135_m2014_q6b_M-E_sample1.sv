module TopModule(
    input  [2:0] y,  // current state encoding
    input  w,
    output Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: begin // A
                // A(0) --0--> B(001): next y[1]=0
                // A(0) --1--> A(000): next y[1]=0
                next_y1 = 1'b0;
            end
            3'b001: begin // B
                // B(001) --0--> C(010): next y[1]=1
                // B(001) --1--> D(011): next y[1]=1
                next_y1 = 1'b1;
            end
            3'b010: begin // C
                // C(010) --0--> E(100): next y[1]=0
                // C(010) --1--> D(011): next y[1]=1
                next_y1 = w ? 1'b1 : 1'b0;
            end
            3'b011: begin // D
                // D(011) --0--> F(101): next y[1]=0
                // D(011) --1--> A(000): next y[1]=0
                next_y1 = 1'b0;
            end
            3'b100: begin // E
                // E(100) --0--> E(100): next y[1]=0
                // E(100) --1--> D(011): next y[1]=1
                next_y1 = w ? 1'b1 : 1'b0;
            end
            3'b101: begin // F
                // F(101) --0--> C(010): next y[1]=1
                // F(101) --1--> D(011): next y[1]=1
                next_y1 = 1'b1;
            end
            default: begin
                next_y1 = 1'b0; // for unused states
            end
        endcase
    end

    assign Y1 = y[1]; // output current y[1]

endmodule