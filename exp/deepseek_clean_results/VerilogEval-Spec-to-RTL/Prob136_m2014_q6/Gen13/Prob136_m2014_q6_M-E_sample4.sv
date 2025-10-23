module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Modified one-hot encoding with only 2 bits changing per transition
    localparam [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;
    reg [5:0] next_state;
    reg next_z;

    // State transition and output prediction
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: begin
                next_state = w ? A : B;
                next_z = 1'b0; // A and B outputs are 0
            end
            state[B]: begin
                next_state = w ? D : C;
                next_z = 1'b0; // B output is 0
            end
            state[C]: begin
                next_state = w ? D : E;
                next_z = w ? 1'b0 : 1'b1; // C->D:0, C->E:1
            end
            state[D]: begin
                next_state = w ? A : F;
                next_z = w ? 1'b0 : 1'b1; // D->A:0, D->F:1
            end
            state[E]: begin
                next_state = w ? D : E;
                next_z = 1'b1; // E output is always 1
            end
            state[F]: begin
                next_state = w ? D : C;
                next_z = 1'b1; // F output is always 1
            end
            default: begin
                next_state = A;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic with output register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end
        else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule