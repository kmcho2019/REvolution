module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State represented with Gray coding: A=00, B=01, C=11, D=10
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A (00)
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay A
                2'b01: state <= in ? 2'b01 : 2'b11;  // B -> B if in=1, else C
                2'b11: state <= in ? 2'b10 : 2'b00;  // C -> D if in=1, else A
                2'b10: state <= in ? 2'b01 : 2'b11;  // D -> B if in=1, else C
            endcase
        end
    end

    // Output is high only in state D (10)
    assign out = (state == 2'b10);

endmodule