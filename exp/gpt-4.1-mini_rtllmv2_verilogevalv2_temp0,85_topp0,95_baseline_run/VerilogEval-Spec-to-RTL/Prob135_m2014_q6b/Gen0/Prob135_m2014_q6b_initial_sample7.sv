module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

// Next state logic for y[1] based on current y and input w
// We'll write a combinational expression for next y[1] (called y1_next).

// Extract current y bits for clarity
wire y0 = y[0];
wire y1 = y[1];
wire y2 = y[2];

// We'll define next state y[1] according to the FSM transitions.
// State codes: A=000, B=001, C=010, D=011, E=100, F=101

// For each state:
// A(000): w=0 -> B(001), next y1 = 0; w=1 -> A(000), y1=0
// B(001): w=0 -> C(010), y1=1; w=1 -> D(011), y1=1
// C(010): w=0 -> E(100), y1=0; w=1 -> D(011), y1=1
// D(011): w=0 -> F(101), y1=0; w=1 -> A(000), y1=0
// E(100): w=0 -> E(100), y1=0; w=1 -> D(011), y1=1
// F(101): w=0 -> C(010), y1=1; w=1 -> D(011), y1=1

// We'll use case or combinational logic to define next y1:

reg y1_next;

always @(*) begin
    case (y)
        3'b000: y1_next = 1'b0; // A
        3'b001: y1_next = 1'b1; // B
        3'b010: y1_next = w ? 1'b1 : 1'b0; // C
        3'b011: y1_next = 1'b0; // D
        3'b100: y1_next = w ? 1'b1 : 1'b0; // E
        3'b101: y1_next = 1'b1; // F
        default: y1_next = 1'b0;
    endcase
end

assign Y1 = y[1];

endmodule