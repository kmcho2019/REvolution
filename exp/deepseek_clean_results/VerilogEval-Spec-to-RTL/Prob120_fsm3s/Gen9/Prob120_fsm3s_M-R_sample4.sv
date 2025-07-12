module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
            out <= 1'b0;
        end
        else begin
            case (state)
                2'b00: begin  // State A
                    state <= in ? 2'b01 : 2'b00;
                    out <= 1'b0;
                end
                2'b01: begin  // State B
                    state <= in ? 2'b01 : 2'b10;
                    out <= 1'b0;
                end
                2'b10: begin  // State C
                    state <= in ? 2'b11 : 2'b00;
                    out <= 1'b0;
                end
                2'b11: begin  // State D
                    state <= in ? 2'b01 : 2'b10;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule