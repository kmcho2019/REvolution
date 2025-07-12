module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
enum logic [2:0] {A, B, C, D, E, F} state;

// Variables to keep track of x sequence and clock cycles
logic [1:0] x_seq;
logic [1:0] y_count;

always_ff @(posedge clk) begin
    if (~resetn) begin
        // Reset to state A
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                // Stay in state A until reset is de-asserted
                state <= B;
                f <= 1;
                g <= 0;
                x_seq <= 0;
                y_count <= 0;
            end
            B: begin
                // Set f to 1 for one clock cycle
                state <= C;
                f <= 0;
            end
            C: begin
                // Monitor x input for sequence 1, 0, 1
                x_seq <= {x_seq[0], x};
                if (x_seq == 3'b101) begin
                    state <= D;
                end
            end
            D: begin
                // Set g to 1 and monitor y input
                g <= 1;
                y_count <= y_count + 1;
                if (y) begin
                    state <= E;
                end else if (y_count == 2) begin
                    state <= F;
                end
            end
            E: begin
                // Maintain g = 1 permanently
                g <= 1;
            end
            F: begin
                // Set g = 0 permanently
                g <= 0;
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule