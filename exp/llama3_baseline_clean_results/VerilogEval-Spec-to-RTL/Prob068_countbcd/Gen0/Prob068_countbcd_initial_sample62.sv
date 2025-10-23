module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] enable;

assign q = count;
assign ena = enable;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        enable <= 3'd0;
    end else begin
        enable <= 3'd0;
        if (count[3:0] == 4'd9) begin
            count[3:0] <= 4'd0;
            enable[0] <= 1'd1;
        end else begin
            count[3:0] <= count[3:0] + 1'd1;
        end

        if (enable[0] && count[7:4] == 4'd9) begin
            count[7:4] <= 4'd0;
            enable[1] <= 1'd1;
        end else if (enable[0]) begin
            count[7:4] <= count[7:4] + 1'd1;
        end

        if (enable[1] && count[11:8] == 4'd9) begin
            count[11:8] <= 4'd0;
            enable[2] <= 1'd1;
        end else if (enable[1]) begin
            count[11:8] <= count[11:8] + 1'd1;
        end

        if (enable[2] && count[15:12] == 4'd9) begin
            count[15:12] <= 4'd0;
        end else if (enable[2]) begin
            count[15:12] <= count[15:12] + 1'd1;
        end
    end
end

endmodule