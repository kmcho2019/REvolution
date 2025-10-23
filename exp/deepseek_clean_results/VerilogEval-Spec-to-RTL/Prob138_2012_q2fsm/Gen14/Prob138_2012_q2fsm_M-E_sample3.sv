module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Transition-optimized state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, predicted_state;
    reg w_prev;
    wire prediction_valid = (w == w_prev); // Clock gating condition

    // State prediction logic (always one step ahead)
    always @(*) begin
        case (current_state)
            A: predicted_state = w ? B : A;
            B: predicted_state = w ? C : D;
            C: predicted_state = w ? E : D;
            D: predicted_state = w ? F : A;
            E: predicted_state = w ? E : D;
            F: predicted_state = w ? C : D;
            default: predicted_state = A;
        endcase
    end

    // State update with clock gating for prediction
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            predicted_state <= A;
            w_prev <= 0;
        end else begin
            current_state <= predicted_state;
            w_prev <= w;
            if (!prediction_valid) begin
                // Only update prediction if w changed
                predicted_state <= w ? 
                    (current_state == A ? B :
                     current_state == B ? C :
                     current_state == C ? E :
                     current_state == D ? F :
                     current_state == E ? E : C) :
                    (current_state == A ? A :
                     current_state == B ? D :
                     current_state == C ? D :
                     current_state == D ? A :
                     current_state == E ? D : D);
            end
        end
    end

    // Early output calculation (from both current and predicted states)
    assign z = (current_state[2] | predicted_state[2]) & 
               (current_state != D); // Special case for D->A transition

endmodule