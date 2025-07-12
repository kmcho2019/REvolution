module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 0;
        q <= 0;
    end else begin
        counter <= counter + 1;
        if (counter > 0) begin
            q <= 1;
        end else begin
            q <= 1;
        end
    end
end

endmodule