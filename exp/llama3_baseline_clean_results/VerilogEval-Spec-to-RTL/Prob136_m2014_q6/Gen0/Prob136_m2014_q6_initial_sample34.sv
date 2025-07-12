module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Enumerate the states
typedef enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110
} state_type;

// Current state register
reg [2:0] current_state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        z <= 0;
    end else begin
        case (current_state)
            A: if (~w) current_state <= B; else current_state <= A;
            B: if (~w) current_state <= C; else current_state <= D;
            C: if (~w) current_state <= E; else current_state <= D;
            D: if (~w) current_state <= F; else current_state <= A;
            E: if (w) current_state <= D; else current_state <= E;
            F: if (w) current_state <= D; else current_state <= C;
            default: current_state <= A; // default to state A
        endcase
        // Set output z based on current state
        case (current_state)
            E, F: z <= 1;
            default: z <= 0;
        endcase
    end
end

endmodule