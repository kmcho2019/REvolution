module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Compact 2-bit state encoding with output differentiation
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // State transition logic optimized for minimal area
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? C : D;  // E shares encoding with C
            D: next_state = w ? D : A;   // F shares encoding with D
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Output logic - states C and D have z=1 when w=1 in previous cycle
    assign z = ((current_state == C) || (current_state == D)) && w;

endmodule