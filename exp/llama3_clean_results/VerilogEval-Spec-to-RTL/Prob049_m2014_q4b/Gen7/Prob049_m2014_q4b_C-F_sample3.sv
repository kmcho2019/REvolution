module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset
    end else if (posedge clk) begin
        q <= d; // Positive edge-triggered clock condition
    end
end

endmodule