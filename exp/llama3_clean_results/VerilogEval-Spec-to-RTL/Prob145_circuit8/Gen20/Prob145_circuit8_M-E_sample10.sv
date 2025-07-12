module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // 0: IDLE, 1: ACTIVE, 2: SET_Q
reg prev_a; // Store the previous value of 'a'

always @(posedge clock) begin
    prev_a <= a;
end

always @(posedge clock) begin
    case (state)
        0: // IDLE
            if (a) begin
                state <= 1; // Transition to ACTIVE
                p <= 1'b1; // Set p high
            end
        1: // ACTIVE
            if (!a) begin
                state <= 0; // Transition back to IDLE
                p <= 1'b0; // Set p low
            end else if (prev_a) begin
                state <= 2; // Transition to SET_Q
            end
        2: // SET_Q
            state <= 0; // Transition back to IDLE
            q <= 1'b1; // Set q high
    endcase
end

always @(negedge clock) begin
    if (a && q) begin
        q <= 1'b0; // Reset q low
    end
end

endmodule