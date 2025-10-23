module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg [1:0] state;
    localparam A = 2'b00;  // Initial/reset state
    localparam B = 2'b01;  // First cycle of window
    localparam C = 2'b10;  // Third cycle of window (output phase)

    // Bit counter (0-3)
    reg [1:0] bit_count;

    // Next state logic
    reg [1:0] next_state;
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = C;  // Always progress to C after B
            C: next_state = B;  // Start new window immediately
            default: next_state = A;
        endcase
    end

    // Output logic - check count at window completion
    assign z = (state == C) && (bit_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            bit_count <= 2'b00;
        end else begin
            state <= next_state;
            
            // Update bit counter
            case (state)
                A: begin
                    bit_count <= 2'b00;  // Reset counter
                end
                B: begin
                    bit_count <= w ? 2'b01 : 2'b00;  // First bit
                end
                C: begin
                    bit_count <= bit_count + (w ? 2'b01 : 2'b00);  // Accumulate
                end
                default: bit_count <= 2'b00;
            endcase
        end
    end

endmodule