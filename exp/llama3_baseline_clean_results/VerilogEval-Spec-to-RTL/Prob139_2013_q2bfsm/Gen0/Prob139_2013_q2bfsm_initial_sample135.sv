module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Enumerate states
enum logic [2:0] {
    A,  // Initial state, reset state
    B,  // State to set f = 1
    C,  // Monitor x for 1, 0, 1 sequence
    D,  // Set g = 1, monitor y
    E   // Set g = 0
} state, nextState;

// Output and internal signals
logic f_next, g_next;
logic [1:0] x_counter;  // Counter for x sequence detection
logic [1:0] y_counter;  // Counter for y timeout detection

// Output assignment
assign f = f_next;
assign g = g_next;

// Combinational logic for next state and output calculation
always_comb begin
    case (state)
        A: begin
            if (~resetn) begin
                nextState = A;
                f_next = 0;
                g_next = 0;
            end else begin
                nextState = B;
                f_next = 1;
                g_next = 0;
            end
        end
        B: begin
            nextState = C;
            f_next = 0;
            g_next = 0;
            x_counter = 0;
        end
        C: begin
            if (x_counter == 0 && x == 1) begin
                x_counter = 1;
            end else if (x_counter == 1 && x == 0) begin
                x_counter = 2;
            end else if (x_counter == 2 && x == 1) begin
                x_counter = 0;
                nextState = D;
                g_next = 1;
            end else begin
                nextState = C;
                g_next = 0;
                if (x_counter != 2 && x != 1) x_counter = 0;
            end
            f_next = 0;
        end
        D: begin
            if (~resetn) begin
                nextState = A;
                f_next = 0;
                g_next = 0;
            end else if (y_counter < 2 && y == 1) begin
                nextState = D;
                f_next = 0;
                g_next = 1;
                y_counter = 0;
            end else if (y_counter < 2) begin
                y_counter = y_counter + 1;
                nextState = D;
                f_next = 0;
                g_next = 1;
            end else begin
                nextState = E;
                f_next = 0;
                g_next = 0;
            end
        end
        E: begin
            if (~resetn) begin
                nextState = A;
                f_next = 0;
                g_next = 0;
            end else begin
                nextState = E;
                f_next = 0;
                g_next = 0;
            end
        end
        default: begin
            nextState = A;
            f_next = 0;
            g_next = 0;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        state <= nextState;
    end
end

endmodule