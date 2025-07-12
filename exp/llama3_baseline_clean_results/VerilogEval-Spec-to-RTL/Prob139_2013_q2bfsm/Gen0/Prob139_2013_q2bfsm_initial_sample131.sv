`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    // Define the states of the FSM
    typedef enum logic [2:0] {
        A = 3'b000, // Reset state
        B = 3'b001, // Set f = 1
        C = 3'b010, // Monitor x for sequence 1, 0, 1
        D = 3'b011, // Set g = 1 and monitor y
        E = 3'b100, // Maintain g = 1 permanently
        F = 3'b101  // Set g = 0 permanently
    } state_type;

    state_type current_state;
    logic [1:0] x_count; // Counter for x sequence
    logic [1:0] y_count; // Counter for y timer

    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
            x_count <= 0;
            y_count <= 0;
        end
        else begin
            case (current_state)
                A: begin
                    current_state <= B;
                    f <= 1;
                    g <= 0;
                end
                B: begin
                    current_state <= C;
                    f <= 0;
                end
                C: begin
                    if (x == 1) begin
                        x_count <= x_count + 1;
                        if (x_count == 3) begin
                            current_state <= D;
                            g <= 1;
                            x_count <= 0;
                        end
                    end
                    else begin
                        x_count <= 0;
                    end
                end
                D: begin
                    y_count <= y_count + 1;
                    if (y == 1 || y_count == 2) begin
                        if (y == 1) begin
                            current_state <= E;
                        end
                        else begin
                            current_state <= F;
                            g <= 0;
                        end
                        y_count <= 0;
                    end
                end
                E, F: begin
                    // No state change
                end
                default: begin
                    current_state <= A;
                end
            endcase
        end
    end

endmodule