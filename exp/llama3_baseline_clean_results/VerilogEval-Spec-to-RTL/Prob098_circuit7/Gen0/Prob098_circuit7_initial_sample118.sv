module TopModule (
    input clk,
    input a,
    output reg q = 1 // Initialize q to 1
);

always @ (posedge clk)
begin
    if (a) begin
        q <= ~q;
    end
end

endmodule