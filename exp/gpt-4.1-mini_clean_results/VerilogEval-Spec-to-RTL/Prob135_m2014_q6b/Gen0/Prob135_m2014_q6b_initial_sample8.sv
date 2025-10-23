module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Next state bit y_next[1]
    // According to the FSM transitions:
    // We'll determine y_next[1] = f(y, w) based on the given state transitions

    // State encoding:
    // A = 000
    // B = 001
    // C = 010
    // D = 011
    // E = 100
    // F = 101

    // Transitions:
    // A(000):
    //  w=0 -> B(001) => y_next[1] = 0
    //  w=1 -> A(000) => y_next[1] = 0
    // B(001):
    //  w=0 -> C(010) => y_next[1] = 1
    //  w=1 -> D(011) => y_next[1] = 1
    // C(010):
    //  w=0 -> E(100) => y_next[1] = 0
    //  w=1 -> D(011) => y_next[1] = 1
    // D(011):
    //  w=0 -> F(101) => y_next[1] = 0
    //  w=1 -> A(000) => y_next[1] = 0
    // E(100):
    //  w=0 -> E(100) => y_next[1] = 0
    //  w=1 -> D(011) => y_next[1] = 1
    // F(101):
    //  w=0 -> C(010) => y_next[1] = 1
    //  w=1 -> D(011) => y_next[1] = 1

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    reg y1_next;

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;              // A
            3'b001: y1_next = 1'b1;              // B
            3'b010: y1_next = (w) ? 1'b1 : 1'b0; // C
            3'b011: y1_next = 1'b0;              // D
            3'b100: y1_next = (w) ? 1'b1 : 1'b0; // E
            3'b101: y1_next = 1'b1;              // F
            default: y1_next = 1'b0;
        endcase
    end

    // Output is current y1
    assign Y1 = y1;

endmodule