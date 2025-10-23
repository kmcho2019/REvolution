module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output logic f,
    output logic g
);

// Define states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state
state_t current_state;

// Temporary variables for tracking x sequence and y timeout
logic [1:0] x_seq;
logic [1:0] y_count;

// Sequential logic to update state and outputs
always_ff @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        case (current_state)
            A: begin
                if (resetn) begin
                    current_state <= B;
                end
            end
            B: begin
                f <= 1;
                current_state <= C;
            end
            C: begin
                x_seq <= {x_seq[0], x};
                f <= 0;
                if (x_seq == 2'b101) begin
                    current_state <= D;
                    x_seq <= 0;
                end
            end
            D: begin
                if (y) begin
                    current_state <= E;
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        current_state <= F;
                    end
                end
            end
            E, F: begin
                // No state change
            end
        endcase
        case (current_state)
            D, E: g <= 1;
            default: g <= 0;
        endcase
    end
end

endmodule