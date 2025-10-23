module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the microcode ROM
reg [2:0] microcodeRom [6][2];

// Initialize the microcode ROM
initial begin
    microcodeRom[A][0] = B;
    microcodeRom[A][1] = A;
    microcodeRom[B][0] = C;
    microcodeRom[B][1] = D;
    microcodeRom[C][0] = E;
    microcodeRom[C][1] = D;
    microcodeRom[D][0] = F;
    microcodeRom[D][1] = A;
    microcodeRom[E][0] = E;
    microcodeRom[E][1] = D;
    microcodeRom[F][0] = C;
    microcodeRom[F][1] = D;
end

// State register
reg [2:0] currentState;
reg [2:0] nextState;

// Output z logic
always @(*) begin
    case (currentState)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (currentState)
        A: nextState = w? microcodeRom[A][1] : microcodeRom[A][0];
        B: nextState = w? microcodeRom[B][1] : microcodeRom[B][0];
        C: nextState = w? microcodeRom[C][1] : microcodeRom[C][0];
        D: nextState = w? microcodeRom[D][1] : microcodeRom[D][0];
        E: nextState = w? microcodeRom[E][1] : microcodeRom[E][0];
        F: nextState = w? microcodeRom[F][1] : microcodeRom[F][0];
        default: nextState = A;
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule