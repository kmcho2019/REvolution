module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
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

    // State registers
    state_t current_state, next_state;

    // Shift register for x pattern detection
    reg [2:0] x_shift;

    // Counter for D state
    reg [1:0] d_counter;

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_shift <= 3'b000;
            d_counter <= 2'b00;
        end else begin
            current_state <= next_state;

            // Update shift register
            x_shift <= {x_shift[1:0], x};

            // State-specific logic
            case (current_state)
                A: begin
                    f <= 0;
                    g <= 0;
                    x_shift <= 3'b000;
                    d_counter <= 2'b00;
                end
                B: begin
                    f <= 1;
                end
                C: begin
                    f <= 0;
                    if (x_shift == 3'b101) begin
                        g <= 1;
                    end
                end
                D: begin
                    d_counter <= d_counter + 1;
                    if (y) begin
                        g <= 1;
                    end else if (d_counter == 2'b10) begin
                        g <= 0;
                    end
                end
                E: begin
                    g <= 1;
                end
                F: begin
                    g <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = resetn ? B : A;
            B: next_state = C;
            C: next_state = (x_shift == 3'b101) ? D : C;
            D: begin
                if (y) begin
                    next_state = E;
                end else if (d_counter == 2'b10) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
            E: next_state = E;
            F: next_state = F;
            default: next_state = A;
        endcase
    end

endmodule