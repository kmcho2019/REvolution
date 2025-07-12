module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

wire gated_clk;
assign gated_clk = clk & (valid_count | !rst_n);

always @(posedge gated_clk) begin
    if (!rst_n) begin
        out <= 4'b0000;       // Synchronous reset
    end
    else begin
        // Optimized state transition logic
        case (out)
            4'b0000: out <= 4'b0001;
            4'b0001: out <= 4'b0010;
            4'b0010: out <= 4'b0011;
            4'b0011: out <= 4'b0100;
            4'b0100: out <= 4'b0101;
            4'b0101: out <= 4'b0110;
            4'b0110: out <= 4'b0111;
            4'b0111: out <= 4'b1000;
            4'b1000: out <= 4'b1001;
            4'b1001: out <= 4'b1010;
            4'b1010: out <= 4'b1011;
            4'b1011: out <= 4'b0000;
            default: out <= 4'b0000;
        endcase
    end
end

endmodule