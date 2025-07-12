module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoded states
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic with one-hot encoding
    always @(*) begin
        // Default no state active
        next_state = 6'b000000;

        if (state == A) begin
            if (w == 1'b0) next_state = B;
            else           next_state = A;
        end else if (state == B) begin
            if (w == 1'b0) next_state = C;
            else           next_state = D;
        end else if (state == C) begin
            if (w == 1'b0) next_state = E;
            else           next_state = D;
        end else if (state == D) begin
            if (w == 1'b0) next_state = F;
            else           next_state = A;
        end else if (state == E) begin
            if (w == 1'b0) next_state = E;
            else           next_state = D;
        end else if (state == F) begin
            if (w == 1'b0) next_state = C;
            else           next_state = D;
        end else begin
            // Default to A if in unknown state
            next_state = A;
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z = 1 when state is E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule