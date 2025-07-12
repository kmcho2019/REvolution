module TopModule (
    input  wire [5:0] y,   // Current one-hot encoded state vector
    input  wire       w,   // FSM input
    output reg        Y1,  // Next state input for flip-flop y[1] (state B)
    output reg        Y3   // Next state input for flip-flop y[3] (state D)
);

    // State encoding (one-hot):
    // y[0] = A
    // y[1] = B
    // y[2] = C
    // y[3] = D
    // y[4] = E
    // y[5] = F

    // Extract current state index from one-hot encoding
    // As y is one-hot, exactly one bit is set.
    // Use priority encoding or direct mapping.
    // Since only one bit set, can identify by position.

    integer i;
    reg [2:0] state_idx;

    always @(*) begin
        // Default outputs low
        Y1 = 1'b0;
        Y3 = 1'b0;
        state_idx = 3'd0;

        // Identify current state index
        // y[0] = 0, y[1] = 1, ..., y[5] = 5
        for (i = 0; i < 6; i = i + 1) begin
            if (y[i]) state_idx = i[2:0];
        end

        // Next-state input logic based on current state and input w
        case (state_idx)
            3'd0: begin // A
                // A(0) --1--> B
                Y1 = w;
                Y3 = 1'b0;
            end
            3'd1: begin // B
                // B(0) --0--> D
                Y1 = 1'b0;
                Y3 = ~w;
            end
            3'd2: begin // C
                // C(0) --0--> D
                Y1 = 1'b0;
                Y3 = ~w;
            end
            3'd3: begin // D
                // D(0) --0--> A (not used here, only Y1 and Y3 outputs)
                // D(0) --1--> F (not related to Y1 or Y3)
                Y1 = 1'b0;
                Y3 = 1'b0; // next state D not entered from D itself
            end
            3'd4: begin // E
                // E(1) --0--> D
                Y1 = 1'b0;
                Y3 = ~w;
            end
            3'd5: begin // F
                // F(1) --0--> D
                Y1 = 1'b0;
                Y3 = ~w;
            end
            default: begin
                Y1 = 1'b0;
                Y3 = 1'b0;
            end
        endcase
    end

endmodule