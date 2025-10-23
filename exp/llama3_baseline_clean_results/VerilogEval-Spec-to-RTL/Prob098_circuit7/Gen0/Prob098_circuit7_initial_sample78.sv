module TopModule (
    input clk,
    input a,
    output reg q
);

// Initialize q to 1
initial q = 1;

always @ (posedge clk) begin
    if (~a) begin
        // If a is 0, keep q as it is
    end else begin
        // If a is 1, set q to 0
        q <= 0;
    end
end

endmodule