module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding: A=00, B=01, C=10, D=11
    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            2'b00: next_state = in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
            2'b01: next_state = in ? 2'b01 : 2'b10;  // B -> C if in=0, else stay
            2'b10: next_state = in ? 2'b11 : 2'b00;  // C -> D if in=1, else A
            2'b11: next_state = in ? 2'b01 : 2'b10;  // D -> B if in=1, else C
        endcase
    end

    // Sequential state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= 2'b00;  // Reset to state A
        else
            current_state <= next_state;
    end

    // Output is high only in state D (11)
    assign out = (current_state == 2'b11);

endmodule