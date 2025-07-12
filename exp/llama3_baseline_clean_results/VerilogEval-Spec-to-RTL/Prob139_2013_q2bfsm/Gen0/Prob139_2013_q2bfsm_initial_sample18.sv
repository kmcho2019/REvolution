module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

typedef enum logic [2:0] {
    A = 3'b000, // Reset state
    B = 3'b001, // Set f to 1
    C = 3'b010, // Monitor x sequence
    D = 3'b011, // Set g to 1
    E = 3'b100, // Monitor y (g stays 1)
    F = 3'b101  // Set g to 0 permanently
} state_t;

state_t state, next_state;
reg [1:0] x_seq_count;
reg [1:0] y_timeout_count;

always @(*) begin
    case (state)
        A: begin
            if (!resetn) next_state = A;
            else next_state = B;
        end
        B: next_state = C;
        C: begin
            if (x_seq_count == 2'b11) next_state = D;
            else next_state = C;
        end
        D: begin
            if (y_timeout_count == 2'b11) next_state = F;
            else if (y) next_state = E;
            else next_state = D;
        end
        E: next_state = E; // Stay here once y is seen
        F: next_state = F; // Stay here once timeout
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_seq_count <= 0;
        y_timeout_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: begin
                f <= 1;
            end
            C: begin
                f <= 0;
                if (x) begin
                    x_seq_count <= x_seq_count + 1;
                end else begin
                    x_seq_count <= 0;
                end
            end
            D: begin
                g <= 1;
                y_timeout_count <= y_timeout_count + 1;
            end
            E: begin
                g <= 1;
                y_timeout_count <= 0; // Reset timeout once y is seen
            end
            F: begin
                g <= 0;
            end
        endcase
    end
end

endmodule