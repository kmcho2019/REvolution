module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding with better Hamming distances
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b111,
                     F = 3'b110;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State transition logic using case for better timing
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Output is MSB of state (E and F have MSB=1)
    assign z = current_state[2];

endmodule