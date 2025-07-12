module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Enum for states
enum logic [2:0] {
    A,  // Initial state
    B,  // Transient state after reset
    C,  // Monitor x input
    D,  // Monitor y input
    E,  // Maintain g = 1 permanently
    F   // Maintain g = 0 permanently
} state, next_state;

// Variables to keep track of sequence and count
logic [1:0] x_sequence;
logic [1:0] y_count;

// Sequential logic
always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            A: begin
                f <= 0;
                g <= 0;
            end
            B: begin
                f <= 1;
                g <= 0;
            end
            C: begin
                f <= 0;
                g <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 1;
            end
            F: begin
                f <= 0;
                g <= 0;
            end
        endcase
        x_sequence <= (x_sequence << 1) | x;
        if (state == D) begin
            y_count <= y_count + 1;
        end else begin
            y_count <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case (state)
        A: begin
            if (resetn) begin
                next_state = B;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            if (x_sequence == 3'b101) begin
                next_state = D;
            end
        end
        D: begin
            if (y || y_count == 2) begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
    endcase
end

endmodule