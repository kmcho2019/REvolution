module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end
        else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
                2'b01: state <= in ? 2'b01 : 2'b10;  // B -> C if in=0, else stay
                2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D if in=1, else A
                2'b11: state <= in ? 2'b01 : 2'b10;  // D -> B if in=1, else C
            endcase
        end
    end

    // Output logic (combinational)
    assign out = (state == 2'b11);  // Output 1 only in state D

endmodule