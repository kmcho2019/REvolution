module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset takes priority
    end else begin
        q <= d; // Update on positive clock edge if no reset
    end
end

endmodule