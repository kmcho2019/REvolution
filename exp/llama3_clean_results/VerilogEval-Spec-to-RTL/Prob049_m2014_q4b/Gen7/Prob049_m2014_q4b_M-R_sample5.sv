module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Combinational logic for prioritizing asynchronous reset
wire reset_q;

assign reset_q = ar ? 1'b0 : d;

always @(posedge clk) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= reset_q;
    end
end

endmodule