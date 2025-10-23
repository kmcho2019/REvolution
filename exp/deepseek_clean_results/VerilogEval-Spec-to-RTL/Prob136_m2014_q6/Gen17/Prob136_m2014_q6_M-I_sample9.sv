module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state;

    // Next state and output logic combined
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            // Parallel case for better synthesis
            // synthesis parallel_case
            case (1'b1) // synthesis parallel_case
                current_state[A]: begin
                    current_state <= w ? A : B;
                    z <= 1'b0;
                end
                current_state[B]: begin
                    current_state <= w ? D : C;
                    z <= 1'b0;
                end
                current_state[C]: begin
                    current_state <= w ? D : E;
                    z <= 1'b0;
                end
                current_state[D]: begin
                    current_state <= w ? A : F;
                    z <= 1'b0;
                end
                current_state[E]: begin
                    current_state <= w ? D : E;
                    z <= 1'b1;
                end
                current_state[F]: begin
                    current_state <= w ? D : C;
                    z <= 1'b1;
                end
                default: begin // Should never happen
                    current_state <= A;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule