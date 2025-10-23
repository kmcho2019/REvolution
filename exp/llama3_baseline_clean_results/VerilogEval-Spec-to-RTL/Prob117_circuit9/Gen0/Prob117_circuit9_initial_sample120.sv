module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (a == 0) begin
        if (count == 3'd7) begin
            count <= 3'd0;
        end else begin
            count <= count + 1'd1;
        end
    end else begin
        count <= 4'd4;
    end
end

assign q = count;

endmodule