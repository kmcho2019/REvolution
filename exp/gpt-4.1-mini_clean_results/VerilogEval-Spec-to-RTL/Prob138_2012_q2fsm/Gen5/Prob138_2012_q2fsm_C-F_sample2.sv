module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // Binary state encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // State flip-flops with synchronous active-high reset and clock gating to reduce toggling
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (state != next_state)
            state <= next_state;
    end

    // Combinational next state logic with explicit default assignment for robustness
    always @(*) begin
        next_state = A;  // default next state to A for safety
        if (state == A) begin
            next_state = w ? B : A;
        end
        else if (state == B) begin
            next_state = w ? C : D;
        end
        else if (state == C) begin
            next_state = w ? E : D;
        end
        else if (state == D) begin
            next_state = w ? F : A;
        end
        else if (state == E) begin
            next_state = w ? E : D;
        end
        else if (state == F) begin
            next_state = w ? C : D;
        end
        else begin
            next_state = A;  // recover from invalid states
        end
    end

    // Registered output logic to reduce glitches and improve timing
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (state == E) || (state == F);
    end

endmodule