module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;
wire en = (d != d_prev);  // Enable when input changes

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
        d_prev <= 8'b0;
    end else if (en) begin
        q <= d;
        d_prev <= d;
    end
end

endmodule