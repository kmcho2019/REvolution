module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (!a && $past(a)) begin // Check for falling edge of a
        if (count == 4) begin // Reset when count reaches 4
            count <= 1;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;

endmodule