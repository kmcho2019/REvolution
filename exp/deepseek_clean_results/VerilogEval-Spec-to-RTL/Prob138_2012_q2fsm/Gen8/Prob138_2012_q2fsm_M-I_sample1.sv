module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding (6 states)
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Combined state transition and output logic
    always @(*) begin
        next_state = A;  // Default to state A
        z = 1'b0;        // Default output
        
        case (1'b1)  // Synthesis will optimize this for one-hot
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
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // z is now registered, eliminating output timing path
        end
    end

endmodule