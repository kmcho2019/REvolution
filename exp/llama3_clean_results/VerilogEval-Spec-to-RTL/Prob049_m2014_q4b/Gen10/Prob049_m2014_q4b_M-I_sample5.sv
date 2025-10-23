module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset directly sets q to 0
    end else if (clk) begin // Check for positive edge of clk
        q <= d; // On positive edge, update q with d
    end
end

endmodule