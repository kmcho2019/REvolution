module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Shift left by 1
            out <= {out[6:0], out[7]};
        end
    end

endmodule