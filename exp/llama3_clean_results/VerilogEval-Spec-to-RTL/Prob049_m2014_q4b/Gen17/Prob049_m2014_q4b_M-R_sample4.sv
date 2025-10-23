module TopModule(
    input clk,
    input ar,
    input d,
    output reg q = 1'b0 // Initialize q with 0
);

always @(posedge ar) begin
    q <= 1'b0; // Asynchronous reset
end

always @(posedge clk) begin
    if (!ar) begin // Ensure reset is not asserted
        q <= d; // Update q on the positive edge of clk
    end
end

endmodule