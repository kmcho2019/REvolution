module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state, next_state;
    reg next_z;

    // State transition logic (combinational)
    always @(*) begin
        next_state = 6'b0;
        next_z = 1'b0;
        
        case (1'b1) // Synthesis parallel case
            state[A]: begin
                next_state = w ? A : B;
                next_z = 1'b0;
            end
            state[B]: begin
                next_state = w ? D : C;
                next_z = 1'b0;
            end
            state[C]: begin
                next_state = w ? D : E;
                next_z = 1'b0;
            end
            state[D]: begin
                next_state = w ? A : F;
                next_z = 1'b0;
            end
            state[E]: begin
                next_state = w ? D : E;
                next_z = 1'b1;
            end
            state[F]: begin
                next_state = w ? D : C;
                next_z = 1'b1;
            end
            default: begin
                next_state = A;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic with output pipeline register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule