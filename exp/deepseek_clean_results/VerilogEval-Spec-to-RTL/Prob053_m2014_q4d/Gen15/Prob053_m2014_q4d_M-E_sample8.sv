module TopModule (
    input clk,
    input in,
    output reg out
);

    // State transition logic
    always @(posedge clk) begin
        case ({in, out})
            2'b00: out <= 1'b0;  // 0 XOR 0 = 0
            2'b01: out <= 1'b1;  // 0 XOR 1 = 1
            2'b10: out <= 1'b1;  // 1 XOR 0 = 1
            2'b11: out <= 1'b0;  // 1 XOR 1 = 0
        endcase
    end

endmodule