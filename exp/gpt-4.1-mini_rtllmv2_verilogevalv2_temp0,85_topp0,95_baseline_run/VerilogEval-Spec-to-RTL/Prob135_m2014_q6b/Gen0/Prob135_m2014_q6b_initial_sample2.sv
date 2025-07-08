module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Next state bit y[1] logic
    // Derive next y[1] bit from the state transition table

    // We'll implement next y[1] as a combinational function of current y and w.
    // To simplify, we analyze the transitions and write next y[1] logic only.

    wire next_y1;

    // The states encoded as:
    // A = 3'b000
    // B = 3'b001
    // C = 3'b010
    // D = 3'b011
    // E = 3'b100
    // F = 3'b101

    // For each transition, we know the next state and can extract y[1] (middle bit).

    // Let's list the transitions and the corresponding next y[1]:

    // State A(000):
    //   w=0 -> B(001) y[1]=0
    //   w=1 -> A(000) y[1]=0

    // State B(001):
    //   w=0 -> C(010) y[1]=1
    //   w=1 -> D(011) y[1]=1

    // State C(010):
    //   w=0 -> E(100) y[1]=0
    //   w=1 -> D(011) y[1]=1

    // State D(011):
    //   w=0 -> F(101) y[1]=0
    //   w=1 -> A(000) y[1]=0

    // State E(100):
    //   w=0 -> E(100) y[1]=0
    //   w=1 -> D(011) y[1]=1

    // State F(101):
    //   w=0 -> C(010) y[1]=1
    //   w=1 -> D(011) y[1]=1

    // Now express next_y1 in terms of current y and w

    // We'll write a combinational logic expression using a case statement.

    reg next_y1_reg;

    always @(*) begin
        case (y)
            3'b000: next_y1_reg = 1'b0;             // A
            3'b001: next_y1_reg = 1'b1;             // B
            3'b010: next_y1_reg = (w) ? 1'b1 : 1'b0; // C
            3'b011: next_y1_reg = 1'b0;             // D
            3'b100: next_y1_reg = (w) ? 1'b1 : 1'b0; // E
            3'b101: next_y1_reg = 1'b1;             // F
            default: next_y1_reg = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule