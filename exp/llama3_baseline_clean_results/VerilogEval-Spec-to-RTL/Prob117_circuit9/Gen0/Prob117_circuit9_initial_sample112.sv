module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

initial count = 0;

always @(posedge clk) begin
    if (~a) begin
        if (count == 6) begin
            count <= 0;
        end
        else if (count == 0) begin
            count <= 1;
        end
        else begin
            count <= count + 1;
        end
    end
    else begin
        if (count == 4) begin
            count <= 4;
        end
    end
end

assign q = count;

endmodule