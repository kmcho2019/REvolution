module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset q to 0 if ar is asserted
    end else begin
        q <= d; // Assign d to q on the positive edge of clk
    end
end

endmodule