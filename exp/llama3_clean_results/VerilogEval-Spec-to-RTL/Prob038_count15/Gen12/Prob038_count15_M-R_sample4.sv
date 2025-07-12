module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Initialize the counter
initial q = 0;

// Counter logic
always @(posedge clk) begin
    case ({reset, q})
        5'b1xxxx: q <= 0; // Reset condition
        default: begin
            if (q == 4'd15) // If counter is at maximum value
                q <= 0; // Reset counter
            else
                q <= q + 1; // Increment counter
        end
    endcase
end

endmodule