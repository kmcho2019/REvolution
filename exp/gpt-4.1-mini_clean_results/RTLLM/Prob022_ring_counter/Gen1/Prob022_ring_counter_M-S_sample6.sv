module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;
    end else begin
        if (out[7] == 1'b1)
            out <= 8'b00000001;
        else
            out <= out << 1;
    end
end

endmodule