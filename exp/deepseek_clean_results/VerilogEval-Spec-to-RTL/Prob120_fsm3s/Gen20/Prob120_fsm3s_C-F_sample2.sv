module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Optimal 2-bit state encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;

    // Single always block for both state transition and reset
    // This reduces combinatorial path compared to two-block approach
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Synchronous reset to state A
        end else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
                2'b01: state <= in ? 2'b01 : 2'b10;  // B -> B if in=1, else C
                2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D if in=1, else A
                2'b11: state <= in ? 2'b01 : 2'b10;  // D -> B if in=1, else C
            endcase
        end
    end

    // Direct output assignment from state bits - most area-efficient
    assign out = (state == 2'b11);  // Output 1 only in state D

endmodule