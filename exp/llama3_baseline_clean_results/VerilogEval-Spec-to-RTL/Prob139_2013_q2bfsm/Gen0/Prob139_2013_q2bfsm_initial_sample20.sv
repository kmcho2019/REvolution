module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum {
    A,  // Reset state
    B,  // Set f to 1 for one clock cycle
    C,  // Monitor x for sequence 1, 0, 1
    D,  // Monitor y for high value within two clock cycles
    E,  // Maintain g = 1 permanently
    F   // Set g = 0 permanently
} state_t;

reg [1:0] x_counter;  // Counter for x sequence
reg [1:0] y_counter;  // Counter for y timeout
state_t current_state;

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
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
                f <= 0;
                if (x) begin
                    if (x_counter == 0) begin
                        x_counter <= 1;
                    end else if (x_counter == 2) begin
                        x_counter <= 0;
                        current_state <= D;
                    end
                end else if (x_counter == 1) begin
                    x_counter <= 2;
                end else begin
                    x_counter <= 0;
                end
            end
            D: begin
                g <= 1;
                y_counter <= 1;
                current_state <= D;
            end
            default: begin
                if (current_state == D) begin
                    if (y) begin
                        current_state <= E;
                    end else if (y_counter == 2) begin
                        current_state <= F;
                    end else begin
                        y_counter <= y_counter + 1;
                    end
                end
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        E: g = 1;
        F: g = 0;
        default: g = g;
    endcase
end

endmodule