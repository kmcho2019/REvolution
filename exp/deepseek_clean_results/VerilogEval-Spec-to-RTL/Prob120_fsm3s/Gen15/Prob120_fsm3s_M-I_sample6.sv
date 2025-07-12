module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray-coded state representation
    reg [1:0] state;

    // State transitions with Gray coding
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A (00)
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00; // A->B or A->A
                2'b01: state <= in ? 2'b01 : 2'b11; // B->B or B->C
                2'b11: state <= in ? 2'b10 : 2'b00; // C->D or C->A
                2'b10: state <= in ? 2'b01 : 2'b11; // D->B or D->C
            endcase
        end
    end

    // Output is high only in state D (10)
    assign out = (state == 2'b10);

endmodule