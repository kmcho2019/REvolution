module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized 2-bit state encoding with z output as MSB
    // States with z=1: E(3), F(2) - these have bit 1 set
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b11,
                     D = 2'b10,
                     E = 2'b11,  // Shares code with C but z different
                     F = 2'b10;  // Shares code with D but z different

    reg [1:0] current_state, next_state;

    // State transition logic - optimized with no default case
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output z is high for states E and F (both have bit 1 set)
    assign z = (current_state == E) || (current_state == F);

endmodule