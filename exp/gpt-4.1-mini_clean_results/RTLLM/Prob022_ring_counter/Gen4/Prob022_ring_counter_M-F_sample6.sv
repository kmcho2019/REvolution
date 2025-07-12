module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Shift left with wrap-around without using concatenation
            out[0] <= out[7];
            for (i = 7; i > 0; i = i - 1) begin
                out[i] <= out[i-1];
            end
        end
    end

endmodule