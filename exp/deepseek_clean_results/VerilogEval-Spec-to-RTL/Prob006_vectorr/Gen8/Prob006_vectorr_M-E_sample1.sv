module TopModule (
    input clk,          // Clock input
    input reset,        // Active-high reset
    input [7:0] in,     // 8-bit input
    output reg [7:0] out // 8-bit reversed output
);

    reg [7:0] temp_reg;  // Temporary working register
    reg [2:0] count;     // Counter for shift operations
    reg busy;            // State indicator

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            temp_reg <= 8'b0;
            out <= 8'b0;
            count <= 3'b0;
            busy <= 1'b0;
        end else begin
            if (!busy) begin
                // Start new reversal operation
                temp_reg <= in;
                count <= 3'b0;
                busy <= 1'b1;
            end else if (count < 3'd7) begin
                // Perform bit reversal shift
                temp_reg <= {temp_reg[6:0], 1'b0};
                out <= {out[6:0], temp_reg[7]};
                count <= count + 1;
            end else begin
                // Final shift and completion
                out <= {out[6:0], temp_reg[7]};
                busy <= 1'b0;
            end
        end
    end

endmodule