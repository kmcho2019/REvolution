module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

typedef enum logic [2:0] {
    A,  // Initial state, reset asserted
    B,  // Set output f to 1 for one clock cycle
    C,  // Monitor x input for sequence 1, 0, 1
    D,  // Set output g to 1 and monitor y input
    E,  // Keep output g set to 1 permanently
    F   // Set output g to 0 permanently
} state_t;

state_t state, next_state;

logic [1:0] x_counter;
logic [1:0] y_counter;

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= A;
        x_counter <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        x_counter <= x_counter + 1;
        y_counter <= y_counter + 1;
        f <= 0;
        g <= 0;
    end
end

always_comb begin
    next_state = state;
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
            if (x_counter == 0 && x) begin
                x_counter = 1;
            end else if (x_counter == 1 && !x) begin
                x_counter = 2;
            end else if (x_counter == 2 && x) begin
                next_state = D;
            end else begin
                x_counter = 0;
            end
        end
        D: begin
            g = 1;
            if (y || y_counter == 1) begin
                next_state = E;
            end else if (y_counter == 2) begin
                next_state = F;
            end else begin
                y_counter = y_counter + 1;
            end
        end
        E: begin
            g = 1;
        end
        F: begin
            g = 0;
        end
    endcase
end

endmodule