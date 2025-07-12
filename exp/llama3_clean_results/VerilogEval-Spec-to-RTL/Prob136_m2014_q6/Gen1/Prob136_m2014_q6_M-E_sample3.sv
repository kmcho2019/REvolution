module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Arrays to store next state and output for each state and input combination
reg [2:0] next_state_array [6][2];
reg [0:0] output_array [6];

// Initialize arrays
initial begin
    // Next state array initialization
    next_state_array[A][0] = B;  // A, w=0 -> B
    next_state_array[A][1] = A;  // A, w=1 -> A
    next_state_array[B][0] = C;  // B, w=0 -> C
    next_state_array[B][1] = D;  // B, w=1 -> D
    next_state_array[C][0] = E;  // C, w=0 -> E
    next_state_array[C][1] = D;  // C, w=1 -> D
    next_state_array[D][0] = F;  // D, w=0 -> F
    next_state_array[D][1] = A;  // D, w=1 -> A
    next_state_array[E][0] = E;  // E, w=0 -> E
    next_state_array[E][1] = D;  // E, w=1 -> D
    next_state_array[F][0] = C;  // F, w=0 -> C
    next_state_array[F][1] = D;  // F, w=1 -> D

    // Output array initialization
    output_array[A] = 1'b0;  // z for state A
    output_array[B] = 1'b0;  // z for state B
    output_array[C] = 1'b0;  // z for state C
    output_array[D] = 1'b0;  // z for state D
    output_array[E] = 1'b1;  // z for state E
    output_array[F] = 1'b1;  // z for state F
end

// Sequential process
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= next_state_array[A][w];
            B: current_state <= next_state_array[B][w];
            C: current_state <= next_state_array[C][w];
            D: current_state <= next_state_array[D][w];
            E: current_state <= next_state_array[E][w];
            F: current_state <= next_state_array[F][w];
            default: current_state <= A;
        endcase
    end
end

// Combinational process for output z
always @(*) begin
    case (current_state)
        A: z <= output_array[A];
        B: z <= output_array[B];
        C: z <= output_array[C];
        D: z <= output_array[D];
        E: z <= output_array[E];
        F: z <= output_array[F];
        default: z <= 1'b0;
    endcase
end

endmodule