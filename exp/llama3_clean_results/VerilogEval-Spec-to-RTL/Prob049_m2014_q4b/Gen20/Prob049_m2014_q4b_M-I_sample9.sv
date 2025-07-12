module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        // Asynchronous reset has priority
        q <= 1'b0;
    end else if (posedge clk) begin
        // On positive clock edge, update q with d
        q <= d;
    end
end

endmodule