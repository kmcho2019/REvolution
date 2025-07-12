module TopModule(clk, reset, w, z);
    input  clk;
    input  reset;
    input  w;
    output z;

    // State codes
    parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

    // Current state register
    reg [2:0] current_state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            case (current_state)
                A: begin
                    if (w) begin
                        current_state <= B;
                    end else begin
                        current_state <= A;
                    end
                end
                B: begin
                    if (w) begin
                        current_state <= C;
                    end else begin
                        current_state <= D;
                    end
                end
                C: begin
                    if (w) begin
                        current_state <= E;
                    end else begin
                        current_state <= D;
                    end
                end
                D: begin
                    if (w) begin
                        current_state <= F;
                    end else begin
                        current_state <= A;
                    end
                end
                E: begin
                    if (w) begin
                        current_state <= E;
                    end else begin
                        current_state <= D;
                    end
                end
                F: begin
                    if (w) begin
                        current_state <= C;
                    end else begin
                        current_state <= D;
                    end
                end
                default: current_state <= A;
            endcase
        end
    end

    // Continuous assignment for output z based on the state
    assign z = (current_state == E || current_state == F);
endmodule