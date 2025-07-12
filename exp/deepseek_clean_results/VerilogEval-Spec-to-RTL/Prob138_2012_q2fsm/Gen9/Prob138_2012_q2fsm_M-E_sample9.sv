module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Rotating one-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state, next_state;
    reg next_z;

    // Mealy-style output computation (pre-registered)
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            current_state[4]: next_z = 1'b1; // E
            current_state[5]: next_z = 1'b1;  // F
            default: next_z = 1'b0;
        endcase
    end

    // Hybrid state transition logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            current_state[0]: next_state = w ? B : A;  // A
            current_state[1]: next_state = w ? C : D;  // B
            current_state[2]: next_state = w ? E : D;   // C
            current_state[3]: next_state = w ? F : A;   // D
            current_state[4]: next_state = w ? E : D;   // E
            current_state[5]: next_state = w ? C : D;   // F
            default: next_state = A;
        endcase
    end

    // Sequential logic with output pipeline
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= next_z;
        end
    end

endmodule