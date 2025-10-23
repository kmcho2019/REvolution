module ring_counter (
    input  clk,
    input  reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;
        end else begin
            if (out[7]) begin
                out <= 8'b0000_0001;  // wrap around
            end else begin
                out <= out << 1;
            end
        end
    end

endmodule