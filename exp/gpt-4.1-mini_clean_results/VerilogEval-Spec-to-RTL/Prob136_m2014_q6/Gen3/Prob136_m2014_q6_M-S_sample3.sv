module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using parameters
    parameter A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        if (state == A) begin
            if (w == 0) next_state = B;
            else next_state = A;
        end else if (state == B) begin
            if (w == 0) next_state = C;
            else next_state = D;
        end else if (state == C) begin
            if (w == 0) next_state = E;
            else next_state = D;
        end else if (state == D) begin
            if (w == 0) next_state = F;
            else next_state = A;
        end else if (state == E) begin
            if (w == 0) next_state = E;
            else next_state = D;
        end else if (state == F) begin
            if (w == 0) next_state = C;
            else next_state = D;
        end else begin
            next_state = A; // default fallback
        end
    end

    // State update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        if (state == E || state == F)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule