module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Combined state transition and output logic
    always @(*) begin
        // Default assignments
        next_state = A;
        z = 1'b0;

        case (1'b1) // Synthesis will recognize this as priority encoder
            current_state[A]: begin
                next_state = w ? B : A;
                z = 1'b0;
            end
            current_state[B]: begin
                next_state = w ? C : D;
                z = 1'b0;
            end
            current_state[C]: begin
                next_state = w ? E : D;
                z = 1'b0;
            end
            current_state[D]: begin
                next_state = w ? F : A;
                z = 1'b0;
            end
            current_state[E]: begin
                next_state = w ? E : D;
                z = 1'b1;
            end
            current_state[F]: begin
                next_state = w ? C : D;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // State storage (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule