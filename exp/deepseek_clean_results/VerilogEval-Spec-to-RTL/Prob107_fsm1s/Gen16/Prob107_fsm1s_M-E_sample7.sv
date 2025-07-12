module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding (even though only 2 states)
    reg [1:0] state;  // bit[0]=B, bit[1]=A
    reg [1:0] next_state;
    
    // Debug signal (not required but useful)
    reg [1:0] prev_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to state B
            out <= 1'b1;
            prev_state <= 2'b00;
        end else begin
            prev_state <= state;
            state <= next_state;
            out <= ~state[1];  // Output is 1 when in state B (bit[0])
        end
    end

    always @(*) begin
        case (1'b1)  // Parallel case
            state[0]: next_state = in ? 2'b01 : 2'b10;  // B transitions
            state[1]: next_state = in ? 2'b10 : 2'b01;  // A transitions
            default: next_state = 2'b01;  // Should never happen
        endcase
    end

endmodule