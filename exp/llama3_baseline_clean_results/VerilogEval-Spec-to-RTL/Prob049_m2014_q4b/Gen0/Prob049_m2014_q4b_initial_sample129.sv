module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(*) begin
    if (ar) begin
        q <= 1'b0; // reset output to 0 when ar is high
    end
end

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // reset output to 0 at posedge of ar
    end else begin
        q <= d; // set output to d at posedge of clk
    end
end

endmodule