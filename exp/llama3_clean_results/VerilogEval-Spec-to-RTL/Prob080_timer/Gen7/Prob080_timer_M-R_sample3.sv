module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
assign tc = (counter == 0);

reg loading;
always @(posedge clk) begin
    if (load) begin
        counter <= data;
        loading <= 1'b1;
    end else if (loading && (counter > 0)) begin
        counter <= counter - 1;
        if (counter == 1) begin
            loading <= 1'b0;
        end
    end
end

endmodule