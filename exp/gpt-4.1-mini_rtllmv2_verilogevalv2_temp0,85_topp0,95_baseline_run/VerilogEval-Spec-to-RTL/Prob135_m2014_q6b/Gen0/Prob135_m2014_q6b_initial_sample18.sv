module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // States encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    // Next state logic for y[1] only

    // Extract current bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg y1_next;

    always @(*) begin
        // Default next y1 value
        y1_next = y1;

        case (y)
            3'b000: begin // A
                // A(0) --0--> B(001)
                // A(0) --1--> A(000)
                // next y1 = B is 0 or A is 0 => 0
                y1_next = 1'b0;
            end
            3'b001: begin // B
                // B(0) --0--> C(010)
                // B(0) --1--> D(011)
                // next y1 = C=1st bit=1, D=1
                if (w == 1'b0)
                    y1_next = 1'b1;
                else
                    y1_next = 1'b1;
            end
            3'b010: begin // C
                // C(0) --0--> E(100)
                // C(0) --1--> D(011)
                // E=100 y1=0, D=011 y1=1
                if (w == 1'b0)
                    y1_next = 1'b0;
                else
                    y1_next = 1'b1;
            end
            3'b011: begin // D
                // D(0) --0--> F(101)
                // D(0) --1--> A(000)
                // F=101 y1=0, A=000 y1=0
                y1_next = 1'b0;
            end
            3'b100: begin // E
                // E(1) --0--> E(100)
                // E(1) --1--> D(011)
                // E=100 y1=0, D=011 y1=1
                if (w == 1'b0)
                    y1_next = 1'b0;
                else
                    y1_next = 1'b1;
            end
            3'b101: begin // F
                // F(1) --0--> C(010)
                // F(1) --1--> D(011)
                // C=010 y1=1, D=011 y1=1
                y1_next = 1'b1;
            end
            default: y1_next = 1'b0; // For completeness
        endcase
    end

    assign Y1 = y1;

endmodule