module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding (A=00, B=01, C=11, D=10)
    reg [1:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end
        else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B or A
                2'b01: state <= in ? 2'b01 : 2'b11;  // B -> B or C
                2'b11: state <= in ? 2'b10 : 2'b00;  // C -> D or A
                2'b10: state <= in ? 2'b01 : 2'b11;  // D -> B or C
            endcase
        end
    end

    // Output is high only in state D (10)
    assign out = state[1] & ~state[0];

endmodule