module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// Define the LUT for next state and output
logic [2:0] lut_ns [6][2];
logic [0:0] lut_z [6];

// Initialize the LUT
initial begin
    lut_ns[A][0] = B;  // A (0) --0--> B
    lut_ns[A][1] = A;  // A (0) --1--> A
    lut_ns[B][0] = C;  // B (0) --0--> C
    lut_ns[B][1] = D;  // B (0) --1--> D
    lut_ns[C][0] = E;  // C (0) --0--> E
    lut_ns[C][1] = D;  // C (0) --1--> D
    lut_ns[D][0] = F;  // D (0) --0--> F
    lut_ns[D][1] = A;  // D (0) --1--> A
    lut_ns[E][0] = E;  // E (1) --0--> E
    lut_ns[E][1] = D;  // E (1) --1--> D
    lut_ns[F][0] = C;  // F (1) --0--> C
    lut_ns[F][1] = D;  // F (1) --1--> D
    
    lut_z[A] = 0;
    lut_z[B] = 0;
    lut_z[C] = 0;
    lut_z[D] = 0;
    lut_z[E] = 1;
    lut_z[F] = 1;
end

// Combinational logic to determine next state and output
always_comb begin
    case (currentState)
        A: nextState = lut_ns[A][w];
        B: nextState = lut_ns[B][w];
        C: nextState = lut_ns[C][w];
        D: nextState = lut_ns[D][w];
        E: nextState = lut_ns[E][w];
        F: nextState = lut_ns[F][w];
        default: nextState = A;
    endcase
    
    z = lut_z[currentState];
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule