module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize to 8'b00000001
        out <= 8'b00000001;
    end
    else begin
        // Shift left and handle wrap-around
        out <= {out[6:0], out[7]};
    end
end

endmodule