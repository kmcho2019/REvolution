module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Output Y1 is y[1]
    assign Y1 = y[1];

    // Next-state logic for y[1]
    // Decode states A=000, B=001, C=010, D=011, E=100, F=101
    // According to transitions:
    // y[2] y[1] y[0] = current state bits
    // For each state, find next state and extract y1 bit
    
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: begin // A
                // A(0) --0--> B(001), y1=0
                // A(0) --1--> A(000), y1=0
                next_y1 = 1'b0;
            end
            3'b001: begin // B
                // B(0) --0--> C(010), y1=1
                // B(0) --1--> D(011), y1=1
                next_y1 = 1'b1;
            end
            3'b010: begin // C
                // C(0) --0--> E(100), y1=0
                // C(0) --1--> D(011), y1=1
                next_y1 = (w == 1'b0) ? 1'b0 : 1'b1;
            end
            3'b011: begin // D
                // D(0) --0--> F(101), y1=0
                // D(0) --1--> A(000), y1=0
                next_y1 = 1'b0;
            end
            3'b100: begin // E
                // E(1) --0--> E(100), y1=0
                // E(1) --1--> D(011), y1=1
                next_y1 = (w == 1'b0) ? 1'b0 : 1'b1;
            end
            3'b101: begin // F
                // F(1) --0--> C(010), y1=1
                // F(1) --1--> D(011), y1=1
                next_y1 = 1'b1;
            end
            default: next_y1 = 1'b0;
        endcase
    end

    // Provide next_y1 as output or for testing
    // Problem statement doesn't require output of next_y1, 
    // so no output port for next_y1.

endmodule