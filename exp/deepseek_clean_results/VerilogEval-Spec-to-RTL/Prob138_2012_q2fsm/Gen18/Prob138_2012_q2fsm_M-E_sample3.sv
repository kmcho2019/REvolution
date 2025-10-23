module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Linear binary state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] current_state, next_state;

    // Binary decision tree for state transitions
    always @(*) begin
        if (reset) begin
            next_state = A;
        end else begin
            // Level 1: Check state[2] (E/F vs others)
            if (current_state[2]) begin
                // E or F states
                if (current_state[0]) begin // F
                    next_state = w ? C : D;
                end else begin // E
                    next_state = w ? E : D;
                end
            end else begin
                // A,B,C,D states
                // Level 2: Check state[1] (C/D vs A/B)
                if (current_state[1]) begin
                    // C or D states
                    if (current_state[0]) begin // D
                        next_state = w ? F : A;
                    end else begin // C
                        next_state = w ? E : D;
                    end
                end else begin
                    // A or B states
                    if (current_state[0]) begin // B
                        next_state = w ? C : D;
                    end else begin // A
                        next_state = w ? B : A;
                    end
                end
            end
        end
    end

    // State storage
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic - E and F are states >= 4
    assign z = (current_state >= E);

endmodule