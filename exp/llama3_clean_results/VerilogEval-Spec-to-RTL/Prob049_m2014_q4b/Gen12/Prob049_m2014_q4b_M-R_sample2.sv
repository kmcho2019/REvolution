module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 0; // Reset q to 0 on asynchronous reset
    end else if (clk) begin // This condition is implicitly true due to posedge clk
        q <= d; // Assign D input to q on the positive edge of clk
    end
end

endmodule