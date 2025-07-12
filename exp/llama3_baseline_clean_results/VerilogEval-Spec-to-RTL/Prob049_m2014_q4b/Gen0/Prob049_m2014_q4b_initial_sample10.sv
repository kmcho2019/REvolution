module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset q to 0 on asynchronous reset
    end else begin
        q <= d; // Capture data on positive edge of clk
    end
end

endmodule