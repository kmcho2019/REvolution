module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // y states encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    // We only implement next-state logic for y[1] (middle bit)

    // Extract current state bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state logic for y[1]
    // We analyze the transitions and determine y[1]_next for each state and input w

    // State A (000): 
    // w=0 -> B(001) y[1]=0
    // w=1 -> A(000) y[1]=0
    // y[1]_next = 0

    // State B (001):
    // w=0 -> C(010) y[1]=1
    // w=1 -> D(011) y[1]=1
    // y[1]_next = 1

    // State C (010):
    // w=0 -> E(100) y[1]=0
    // w=1 -> D(011) y[1]=1
    // y[1]_next = w

    // State D (011):
    // w=0 -> F(101) y[1]=0
    // w=1 -> A(000) y[1]=0
    // y[1]_next = 0

    // State E (100):
    // w=0 -> E(100) y[1]=0
    // w=1 -> D(011) y[1]=1
    // y[1]_next = w

    // State F (101):
    // w=0 -> C(010) y[1]=1
    // w=1 -> D(011) y[1]=1
    // y[1]_next = 1

    // Summarize y[1]_next by state and w:
    // A(000): 0
    // B(001): 1
    // C(010): w
    // D(011): 0
    // E(100): w
    // F(101): 1

    // We can write a logic expression for y[1]_next based on y and w

    // Let's define a signal for each state:
    wire A = (y == 3'b000);
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    wire y1_next = (B) | (C & w) | (E & w) | (F);

    assign Y1 = y1;

endmodule