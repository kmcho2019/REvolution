module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Modified one-hot encoding with shared bit for E/F
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b110000,
                    F = 6'b100000;

    reg [5:0] state;
    reg [5:0] next_state_0, next_state_1;
    reg next_z_0, next_z_1;

    // Parallel next state computation
    always @(*) begin
        // Compute all possible next states for w=0 and w=1
        case (1'b1) // synthesis parallel_case
            state[A]: begin
                next_state_0 = B;
                next_state_1 = A;
                next_z_0 = 0;
                next_z_1 = 0;
            end
            state[B]: begin
                next_state_0 = C;
                next_state_1 = D;
                next_z_0 = 0;
                next_z_1 = 0;
            end
            state[C]: begin
                next_state_0 = E;
                next_state_1 = D;
                next_z_0 = 1;
                next_z_1 = 0;
            end
            state[D]: begin
                next_state_0 = F;
                next_state_1 = A;
                next_z_0 = 1;
                next_z_1 = 0;
            end
            state[E]: begin
                next_state_0 = E;
                next_state_1 = D;
                next_z_0 = 1;
                next_z_1 = 0;
            end
            state[F]: begin
                next_state_0 = C;
                next_state_1 = D;
                next_z_0 = 0;
                next_z_1 = 0;
            end
            default: begin
                next_state_0 = A;
                next_state_1 = A;
                next_z_0 = 0;
                next_z_1 = 0;
            end
        endcase
    end

    // State and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            state <= w ? next_state_1 : next_state_0;
            z <= w ? next_z_1 : next_z_0;
        end
    end

endmodule