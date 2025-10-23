module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Gray-coded state representation (A=00, B=01, C=11, D=10)
    reg [1:0] state;

    // Next state logic
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
            2'b01: next_state = in ? 2'b01 : 2'b11;  // B -> C if in=0, else stay
            2'b11: next_state = in ? 2'b10 : 2'b00;  // C -> D if in=1, else A
            2'b10: next_state = in ? 2'b01 : 2'b11;   // D -> B if in=1, else C
            default: next_state = 2'b00;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

    // Registered output (one cycle latency but better timing)
    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            out <= (state == 2'b10);  // Output high only in state D
        end
    end

endmodule