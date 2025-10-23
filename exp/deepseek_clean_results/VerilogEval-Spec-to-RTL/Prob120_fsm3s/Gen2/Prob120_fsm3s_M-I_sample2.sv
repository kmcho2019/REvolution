module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Gray-coded state representation (A=00, B=01, C=11, D=10)
    reg [1:0] state;

    // State transition logic with Gray coding
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
            out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin  // State A
                    state <= in ? 2'b01 : 2'b00;  // A->B if in=1, else stay
                    out <= 1'b0;
                end
                2'b01: begin  // State B
                    state <= in ? 2'b01 : 2'b11;  // B->C if in=0, else stay
                    out <= 1'b0;
                end
                2'b11: begin  // State C
                    state <= in ? 2'b10 : 2'b00;  // C->D if in=1, else A
                    out <= 1'b0;
                end
                2'b10: begin  // State D
                    state <= in ? 2'b01 : 2'b11;  // D->B if in=1, else C
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule