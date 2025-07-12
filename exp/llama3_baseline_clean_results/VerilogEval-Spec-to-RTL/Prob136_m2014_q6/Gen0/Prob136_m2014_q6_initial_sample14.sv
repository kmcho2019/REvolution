module TopModule (
    input  clk,
    input  reset,
    input  w,
    output logic z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Register to store the current state
state_t current_state;

// Determine the next state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (w) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= C;
                end
            end
            C: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= E;
                end
            end
            D: begin
                if (w) begin
                    current_state <= A;
                end else begin
                    current_state <= F;
                end
            end
            E: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= E;
                end
            end
            F: begin
                if (w) begin
                    current_state <= D;
                end else begin
                    current_state <= C;
                end
            end
            default: begin
                current_state <= A;
            end
        endcase
    end
end

// Determine the output 'z'
always_comb begin
    case (current_state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule