module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    // On reset, initialize out to 0000_0001
    // On each clock rising edge, rotate the bits left by 1
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;
        end else begin
            out <= {out[6:0], out[7]};
        end
    end

endmodule