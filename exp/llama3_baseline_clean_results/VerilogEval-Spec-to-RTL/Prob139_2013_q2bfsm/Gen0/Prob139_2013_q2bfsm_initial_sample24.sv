module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Enumerate the states
enum logic [2:0] {A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101} state, next_state;

// Internal signals to track x sequence and y timeout
logic [1:0] x_sequence;
logic [1:0] y_timeout;

always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        x_sequence <= 0;
        y_timeout <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                f <= 1;
                state <= C;
                x_sequence <= 0;
            end
            C: begin
                f <= 0; // Reset f after one cycle
                case (x_sequence)
                    2'b00: begin
                        if (x) begin
                            x_sequence <= x_sequence + 1;
                        end else begin
                            x_sequence <= 0;
                        end
                    end
                    2'b01: begin
                        if (~x) begin
                            x_sequence <= x_sequence + 1;
                        end else begin
                            x_sequence <= 0;
                        end
                    end
                    2'b10: begin
                        if (x) begin
                            state <= D;
                            x_sequence <= 0;
                        end else begin
                            x_sequence <= 0;
                        end
                    end
                    default: begin
                        x_sequence <= 0;
                    end
                endcase
            end
            D: begin
                g <= 1;
                y_timeout <= y_timeout + 1;
                if (y || y_timeout == 2) begin
                    if (y) begin
                        state <= E;
                    end else begin
                        state <= F;
                    end
                end
            end
            E: begin
                g <= 1;
            end
            F: begin
                g <= 0;
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule