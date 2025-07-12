module TopModule(
    input clk,
    input reset,
    input w,
    output logic z
);

logic [2:0] state;
logic [2:0] next_state;

// Define the lookup tables for next state and output z
logic [2:0] next_state_lut [6][2] = {
    {3'b001, 3'b000}, // A
    {3'b010, 3'b011}, // B
    {3'b100, 3'b011}, // C
    {3'b101, 3'b000}, // D
    {3'b100, 3'b011}, // E
    {3'b010, 3'b011}  // F
};

logic [0:0] z_lut [6] = {
    1'b0, // A
    1'b0, // B
    1'b0, // C
    1'b0, // D
    1'b1, // E
    1'b1  // F
};

// Define the state encoding
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
};

always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        A: next_state = w? A : B;
        B: next_state = w? D : C;
        C: next_state = w? D : E;
        D: next_state = w? A : F;
        E: next_state = w? D : E;
        F: next_state = w? D : C;
        default: next_state = A;
    endcase
    z = z_lut[state];
end

endmodule