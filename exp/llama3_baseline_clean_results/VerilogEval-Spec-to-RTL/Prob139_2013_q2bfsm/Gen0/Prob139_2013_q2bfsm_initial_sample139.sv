module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enum for states
enum {A, B, C, D, E_G1, E_G0} state;

// Counter for x sequence
reg [1:0] x_seq;

// Counter for y monitoring
reg [1:0] y_count;

always @(posedge clk) begin
    if (~resetn) begin // Reset condition
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin // Initial state, wait for resetn to be high
                if (resetn) begin
                    state <= B;
                    f <= 1;
                end else begin
                    state <= A;
                    f <= 0;
                end
            end
            B: begin // Set output f to 1 for one clock cycle
                state <= C;
                f <= 0;
            end
            C: begin // Monitor x input for sequence 1, 0, 1
                case (x_seq)
                    0: begin // First 1 in sequence
                        if (x) x_seq <= 1;
                    end
                    1: begin // Second 0 in sequence
                        if (~x) x_seq <= 2;
                        else x_seq <= 0;
                    end
                    2: begin // Third 1 in sequence
                        if (x) begin
                            state <= D;
                            g <= 1;
                            y_count <= 0;
                        end else x_seq <= 0;
                    end
                endcase
            end
            D: begin // Monitor y input
                if (y) state <= E_G1; // y is 1 within two clock cycles
                else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) state <= E_G0; // y is not 1 within two clock cycles
                end
            end
            E_G1: begin // Maintain g = 1 permanently
                g <= 1;
            end
            E_G0: begin // Set g = 0 permanently
                g <= 0;
            end
            default: state <= A; // Default state
        endcase
    end
end

endmodule