module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire is_nine = q[3] & ~q[2] & ~q[1] & q[0];  // Pattern detector for 9 (1001)
reg slowena_reg;

always @(posedge clk) begin
    slowena_reg <= slowena;  // Register enable signal to break timing path
    
    if (reset) begin
        q <= 4'b0000;  // Synchronous reset to 0
    end
    else if (slowena_reg) begin
        if (is_nine) begin
            q <= 4'b0000;  // Wrap around to 0
        end
        else begin
            // Gray code increment sequence
            case (q)
                4'b0000: q <= 4'b0001;
                4'b0001: q <= 4'b0011;
                4'b0011: q <= 4'b0010;
                4'b0010: q <= 4'b0110;
                4'b0110: q <= 4'b0111;
                4'b0111: q <= 4'b0101;
                4'b0101: q <= 4'b0100;
                4'b0100: q <= 4'b1100;
                4'b1100: q <= 4'b1101;
                4'b1101: q <= 4'b1001;
                default: q <= 4'b0000;
            endcase
        end
    end
end

endmodule