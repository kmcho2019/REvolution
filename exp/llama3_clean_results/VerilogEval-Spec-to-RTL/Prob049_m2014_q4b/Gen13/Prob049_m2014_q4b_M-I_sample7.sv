module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin // Asynchronous reset has higher priority
        q <= 1'b0;
    end else begin // Only consider clock edge when not in reset
        q <= d;
    end
end

endmodule