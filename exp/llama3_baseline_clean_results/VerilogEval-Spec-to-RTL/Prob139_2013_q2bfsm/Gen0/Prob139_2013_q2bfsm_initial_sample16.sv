module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

typedef enum logic [2:0] {
    A, // Initial state
    B, // State to set f to 1
    C, // Monitor x for 1, 0, 1
    D, // Set g to 1 and monitor y
    E, // g remains 1 permanently
    F  // g is 0 permanently
} state_t;

state_t current_state, next_state;
reg [1:0] x_counter; // Counter for x sequence
reg [1:0] y_counter; // Counter for y timeout

always @(*) begin
    case (current_state)
        A: begin
            if (~resetn) begin
                next_state = A;
                f = 0;
                g = 0;
            end else begin
                next_state = B;
                f = 0;
                g = 0;
            end
        end
        B: begin
            next_state = C;
            f = 1;
            g = 0;
        end
        C: begin
            if (x_counter == 2'd0 && x) begin
                x_counter = x_counter + 1;
                next_state = C;
                f = 0;
                g = 0;
            end else if (x_counter == 2'd1 && ~x) begin
                x_counter = x_counter + 1;
                next_state = C;
                f = 0;
                g = 0;
            end else if (x_counter == 2'd2 && x) begin
                x_counter = 2'd0;
                next_state = D;
                f = 0;
                g = 1;
            end else begin
                x_counter = x_counter;
                next_state = C;
                f = 0;
                g = 0;
            end
        end
        D: begin
            if (y || (y_counter == 2'd1)) begin
                y_counter = 2'd0;
                next_state = E;
                f = 0;
                g = 1;
            end else begin
                y_counter = y_counter + 1;
                next_state = D;
                f = 0;
                g = 1;
            end
        end
        E: begin
            next_state = E;
            f = 0;
            g = 1;
        end
        F: begin
            next_state = F;
            f = 0;
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        x_counter <= 2'd0;
        y_counter <= 2'd0;
    end else begin
        current_state <= next_state;
    end
end

endmodule