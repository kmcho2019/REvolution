module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0; // If a is 1, set q to 0
    end else begin
        if (q == 1'b0) begin
            q <= 0; // If q is already 0, keep it 0
        end else begin
            q <= 1; // If q is 1 and a is 0, keep q 1
        end
    end
end

endmodule