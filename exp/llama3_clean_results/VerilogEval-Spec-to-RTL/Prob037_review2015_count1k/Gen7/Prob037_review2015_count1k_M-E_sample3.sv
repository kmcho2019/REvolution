module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] lower_count;
reg [5:0] upper_count;

always @(posedge clk) begin
    if (reset) begin
        lower_count <= 4'd0;
        upper_count <= 6'd0;
    end else begin
        if (lower_count == 4'd9) begin
            lower_count <= 4'd0;
            if (upper_count == 6'd139) begin
                upper_count <= 6'd0;
            end else begin
                upper_count <= upper_count + 6'd1;
            end
        end else begin
            lower_count <= lower_count + 4'd1;
        end
    end
end

assign q = {upper_count, lower_count};

endmodule