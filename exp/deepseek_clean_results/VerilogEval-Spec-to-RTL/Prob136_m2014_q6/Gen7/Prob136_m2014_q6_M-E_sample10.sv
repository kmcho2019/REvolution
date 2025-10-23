module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding - simple binary for efficient decoding
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,
        F = 3'b101;

    reg [2:0] current_state;

    // Parallel next state calculation for all possible transitions
    wire [2:0] next_A = w ? A : B;
    wire [2:0] next_B = w ? D : C;
    wire [2:0] next_C = w ? D : E;
    wire [2:0] next_D = w ? A : F;
    wire [2:0] next_E = w ? D : E;
    wire [2:0] next_F = w ? D : C;

    // Next state multiplexer
    reg [2:0] next_state;
    always @(*) begin
        case (current_state)
            A: next_state = next_A;
            B: next_state = next_B;
            C: next_state = next_C;
            D: next_state = next_D;
            E: next_state = next_E;
            F: next_state = next_F;
            default: next_state = A;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic - separate from state encoding
    assign z = (current_state == E) | (current_state == F);

endmodule