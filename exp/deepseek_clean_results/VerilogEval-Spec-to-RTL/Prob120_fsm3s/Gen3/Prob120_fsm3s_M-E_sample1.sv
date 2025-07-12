module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=0, B=1, C=2, D=3)
    reg [1:0] state;

    // Next state logic using arithmetic operations
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00; // A -> B or A
                2'b01: state <= in ? 2'b01 : 2'b10; // B -> B or C
                2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D or A
                2'b11: state <= in ? 2'b01 : 2'b10; // D -> B or C
            endcase
        end
    end

    // Output is high only in state D (3)
    assign out = (state == 2'b11);

endmodule