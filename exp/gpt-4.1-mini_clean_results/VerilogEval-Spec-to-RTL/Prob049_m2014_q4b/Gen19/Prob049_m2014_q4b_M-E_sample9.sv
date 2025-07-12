module TopModule (
    input clk,
    input ar,    // Asynchronous active-high reset
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!ar) begin
        q <= d;          // Capture data on rising clock edge when not in reset
    end
end

always @(posedge ar) begin
    q <= 1'b0;           // Asynchronous reset sets q to 0 immediately on ar rising edge
end

endmodule