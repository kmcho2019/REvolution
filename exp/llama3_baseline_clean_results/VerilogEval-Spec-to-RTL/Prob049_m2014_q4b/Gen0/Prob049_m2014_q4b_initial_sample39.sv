module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset q to 0 when ar is high
    end else if (posedge clk) begin
        q <= d; // Update q with d on the rising edge of clk
    end
end

endmodule