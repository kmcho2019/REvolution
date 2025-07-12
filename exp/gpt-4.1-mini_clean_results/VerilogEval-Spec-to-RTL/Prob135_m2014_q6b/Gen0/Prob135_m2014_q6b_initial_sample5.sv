module TopModule(
    input       w,
    input [2:0] y,
    output      Y1
);
    // Next state logic for y[1]
    // State codes: A=000, B=001, C=010, D=011, E=100, F=101
    // Implement next state logic only for y[1]
    // Current state = y[2:0], next state y_next[2:0]
    // But we implement only y_next[1], others stay same.

    wire y1_next;

    // Derive y1_next using the transitions:
    // From the state table:
    // States with y[1] = 0: A(000), B(001), C(010), F(101)
    // States with y[1] = 1: D(011), E(100)

    // Let's list all transitions for y[1]:

    // A(000):
    // w=0 -> B(001): y1=0 -> 0
    // w=1 -> A(000): y1=0 -> 0
    // y1_next=0

    // B(001):
    // w=0 -> C(010): y1=1
    // w=1 -> D(011): y1=1
    // y1_next=1

    // C(010):
    // w=0 -> E(100): y1=0
    // w=1 -> D(011): y1=1
    // So y1_next = w

    // D(011):
    // w=0 -> F(101): y1=0
    // w=1 -> A(000): y1=0
    // y1_next=0

    // E(100):
    // w=0 -> E(100): y1=0
    // w=1 -> D(011): y1=1
    // y1_next = w

    // F(101):
    // w=0 -> C(010): y1=1
    // w=1 -> D(011): y1=1
    // y1_next=1

    // Summarize:
    // State A(000): y=000, y1=0, next y1=0
    // State B(001): y=001, y1=0, next y1=1
    // State C(010): y=010, y1=1, next y1=w
    // State D(011): y=011, y1=1, next y1=0
    // State E(100): y=100, y1=0, next y1=w
    // State F(101): y=101, y1=0, next y1=1

    // Let's write the logic expression for y1_next:
    // Use y[2], y[1], y[0], and w

    // Detect states:
    wire A = (y == 3'b000);
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    assign y1_next = (B) ? 1'b1 :
                     (C) ? w :
                     (D) ? 1'b0 :
                     (E) ? w :
                     (F) ? 1'b1 :
                     1'b0; // For A or others

    assign Y1 = y[1];

endmodule