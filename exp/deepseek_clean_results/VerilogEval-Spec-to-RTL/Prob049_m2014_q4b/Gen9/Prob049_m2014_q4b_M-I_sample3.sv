module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg ar_sync;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        ar_sync <= 1'b1;
        q <= 1'b0;
    end else begin
        ar_sync <= 1'b0;
        q <= d;
    end
end

endmodule