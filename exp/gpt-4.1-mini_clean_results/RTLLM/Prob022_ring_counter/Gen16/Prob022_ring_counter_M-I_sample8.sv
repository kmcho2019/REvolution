module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            if (out[7] == 1'b0) begin
                out <= out << 1;
            end else begin
                out <= (out << 1) | 8'b00000001;
            end
        end
    end

endmodule