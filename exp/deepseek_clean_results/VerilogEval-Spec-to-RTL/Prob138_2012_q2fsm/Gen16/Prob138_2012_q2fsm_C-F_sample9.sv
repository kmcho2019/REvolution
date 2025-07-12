module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding - Gray-like with single-bit transitions
    // and MSB=1 for states E and F (where z=1)
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b100;

    reg [2:0] state;

    // State transition logic - case statement for readability
    // with flattened conditions for better synthesis
    always @(*) begin
        case (state)
            A: state = w ? B : A;
            B: state = w ? C : D;
            C: state = w ? E : D;
            D: state = w ? F : A;
            E: state = w ? E : D;
            F: state = w ? C : D;
            default: state = A;  // Handle any undefined states
        endcase
    end

    // State register with compact synchronous reset
    always @(posedge clk) begin
        state <= reset ? A : state;
    end

    // Output logic - direct bit select for maximum efficiency
    assign z = state[2];

endmodule