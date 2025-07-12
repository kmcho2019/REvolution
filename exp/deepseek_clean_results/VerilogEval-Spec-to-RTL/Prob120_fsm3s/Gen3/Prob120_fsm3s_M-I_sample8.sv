module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray-coded state representation (A=00, B=01, C=11, D=10)
    reg [1:0] state_counter;

    // State transition logic with Gray coding
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 2'b00;  // Reset to state A (00)
        end else begin
            case (state_counter)
                2'b00: state_counter <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
                2'b01: state_counter <= in ? 2'b01 : 2'b11;  // B -> C if in=0, else stay
                2'b11: state_counter <= in ? 2'b10 : 2'b00;  // C -> D if in=1, else A
                2'b10: state_counter <= in ? 2'b01 : 2'b11;  // D -> B if in=1, else C
            endcase
        end
    end

    // Optimized output logic - high only in state D (10)
    assign out = state_counter[1] & ~state_counter[0];

endmodule