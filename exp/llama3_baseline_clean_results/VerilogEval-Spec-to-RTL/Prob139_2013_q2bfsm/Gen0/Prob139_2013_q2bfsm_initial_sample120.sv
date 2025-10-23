module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states
enum logic [2:0] {
    A = 3'b000, // Initial state
    B = 3'b001, // Set f to 1
    C = 3'b010, // Monitor x sequence
    D = 3'b011, // Monitor y
    E = 3'b100, // g = 1 permanently
    F = 3'b101  // g = 0 permanently
} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    f = 0;
    g = 0;
    case (state)
        A: begin
            if (resetn) begin
                next_state = B;
            end
        end
        B: begin
            f = 1;
            next_state = C;
        end
        C: begin
            static logic [1:0] x_sequence = 2'b00;
            x_sequence = {x_sequence[0], x};
            if (x_sequence == 2'b101) begin
                next_state = D;
            end
        end
        D: begin
            static logic [1:0] y_counter = 2'b00;
            g = 1;
            if (y) begin
                next_state = E;
            end else begin
                y_counter = y_counter + 1;
                if (y_counter == 2'b10) begin
                    next_state = F;
                end
            end
        end
        E: begin
            g = 1;
        end
        F: begin
            // Do nothing
        end
    endcase
end

endmodule