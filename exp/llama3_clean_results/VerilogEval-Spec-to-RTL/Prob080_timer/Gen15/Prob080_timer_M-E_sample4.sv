module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

reg [9:0] internal_count;
reg counting;

always @(posedge clk)
begin
    if (load) begin
        internal_count <= data;
        counting <= 1'b1;
        tc <= 1'b0;
    end else if (counting) begin
        if (internal_count == 10'd0) begin
            counting <= 1'b0;
            tc <= 1'b1;
        end else begin
            internal_count <= internal_count - 1;
        end
    end
end

endmodule