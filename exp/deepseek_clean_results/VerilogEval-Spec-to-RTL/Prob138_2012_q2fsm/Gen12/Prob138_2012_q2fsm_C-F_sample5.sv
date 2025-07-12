module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimal state encoding for minimal transitions
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state;
    wire [2:0] next_state;

    // State transition logic - case statement for best synthesis
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Robust default case
        endcase
    end

    // State storage with compact reset integration
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Minimal output logic - direct bit check
    assign z = current_state[2];

endmodule