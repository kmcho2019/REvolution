module TopModule (
    input wire clk,
    input wire reset,
    input wire [2:0] y,
    input wire w,
    output wire Y1
);
    reg [2:0] state;

    // State encoding
    // A=000, B=001, C=010, D=011, E=100, F=101
    // Implement next state for y[1] only, others hold current value

    wire next_y1;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= 3'b000; // Reset to state A
        else
            state <= {state[2], next_y1, state[0]};
    end

    // Next state logic for y[1]
    // Define next y[1] based on current state and w
    // Transition table:
    // A(000) w=0 -> B(001) y1=0, w=1 -> A(000) y1=0
    // B(001) w=0 -> C(010) y1=1, w=1 -> D(011) y1=1
    // C(010) w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // D(011) w=0 -> F(101) y1=0, w=1 -> A(000) y1=0
    // E(100) w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // F(101) w=0 -> C(010) y1=1, w=1 -> D(011) y1=1

    assign next_y1 =
        (state == 3'b000 && (w == 1'b0)) ? 1'b0 : // A->B y1=0
        (state == 3'b000 && (w == 1'b1)) ? 1'b0 : // A->A y1=0
        (state == 3'b001 && (w == 1'b0)) ? 1'b1 : // B->C y1=1
        (state == 3'b001 && (w == 1'b1)) ? 1'b1 : // B->D y1=1
        (state == 3'b010 && (w == 1'b0)) ? 1'b0 : // C->E y1=0
        (state == 3'b010 && (w == 1'b1)) ? 1'b1 : // C->D y1=1
        (state == 3'b011 && (w == 1'b0)) ? 1'b0 : // D->F y1=0
        (state == 3'b011 && (w == 1'b1)) ? 1'b0 : // D->A y1=0
        (state == 3'b100 && (w == 1'b0)) ? 1'b0 : // E->E y1=0
        (state == 3'b100 && (w == 1'b1)) ? 1'b1 : // E->D y1=1
        (state == 3'b101 && (w == 1'b0)) ? 1'b1 : // F->C y1=1
        (state == 3'b101 && (w == 1'b1)) ? 1'b1 : // F->D y1=1
        state[1]; // Default hold

    assign Y1 = state[1];

endmodule