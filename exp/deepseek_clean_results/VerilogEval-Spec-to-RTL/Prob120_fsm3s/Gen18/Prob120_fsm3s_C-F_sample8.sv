module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding with Gray-like properties (A=00, B=01, C=11, D=10)
    // Modified to have single-bit changes between frequently visited states
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            case ({state, in})
                3'b000: state <= 2'b00;  // A,0->A
                3'b001: state <= 2'b01;  // A,1->B (single bit change)
                3'b010: state <= 2'b11;  // B,0->C (single bit change)
                3'b011: state <= 2'b01;  // B,1->B
                3'b100: state <= 2'b00;  // D,0->C (treated as 10->11)
                3'b101: state <= 2'b01;  // D,1->B (10->01)
                3'b110: state <= 2'b00;  // C,0->A (11->00)
                3'b111: state <= 2'b10;  // C,1->D (11->10, single bit change)
            endcase
        end
    end

    // Output is high only in state D (10)
    assign out = state[1] & ~state[0];

endmodule