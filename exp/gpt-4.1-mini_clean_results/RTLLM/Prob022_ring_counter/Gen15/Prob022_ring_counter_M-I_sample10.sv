module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001;
        end else begin
            reg msb;
            reg [7:0] temp;

            msb = out[7];
            temp = out << 1;
            temp[0] = msb;

            out <= temp;
        end
    end

endmodule