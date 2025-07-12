module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        // LFSR-style binary counter
        count[0] <= ~count[0];
        count[1] <= count[0] ? ~count[1] : count[1];
        count[2] <= (count[1:0] == 2'b11) ? ~count[2] : count[2];
        count[3] <= (count[2:0] == 3'b111) ? ~count[3] : count[3];
    end
end

assign q = count;

endmodule