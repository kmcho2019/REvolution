module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state;

    // Moore output (depends only on current state)
    assign out = (state == 2'b11);  // State D

    // State transitions with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // State A
        else case (state)
            2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay A
            2'b01: state <= in ? 2'b01 : 2'b10;  // B -> B if in=1, else C
            2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D if in=1, else A
            2'b11: state <= in ? 2'b01 : 2'b10;  // D -> B if in=1, else C
            default: state <= 2'b00;             // Should never happen
        endcase
    end

endmodule