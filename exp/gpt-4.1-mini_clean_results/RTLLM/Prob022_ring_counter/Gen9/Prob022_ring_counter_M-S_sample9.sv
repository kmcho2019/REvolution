module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // Initialize with LSB=1
        end else begin
            // Find which bit is set and shift to next bit
            // Since only one bit is set at any time, we can find it by checking bits
            for (i = 0; i < 8; i = i + 1) begin
                if (out[i]) begin
                    if (i == 7)
                        out <= 8'b00000001; // wrap around
                    else
                        out <= 8'b00000001 << (i + 1);
                    disable for; // exit loop after updating
                end
            end
        end
    end

endmodule