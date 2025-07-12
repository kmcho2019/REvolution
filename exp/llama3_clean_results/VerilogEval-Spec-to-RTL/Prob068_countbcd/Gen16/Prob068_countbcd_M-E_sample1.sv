module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] enable;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        enable <= 3'b000;
    end else begin
        // ones digit
        if (count[3:0] == 4'd9) begin
            count[3:0] <= 4'd0;
            enable[0] <= 1'b1;
        end else begin
            count[3:0] <= count[3:0] + 1;
            enable[0] <= 1'b0;
        end
        
        // tens digit
        if (enable[0] && count[7:4] == 4'd9) begin
            count[7:4] <= 4'd0;
            enable[1] <= 1'b1;
        end else if (enable[0]) begin
            count[7:4] <= count[7:4] + 1;
            enable[1] <= 1'b0;
        end else begin
            enable[1] <= 1'b0;
        end
        
        // hundreds digit
        if (enable[1] && count[11:8] == 4'd9) begin
            count[11:8] <= 4'd0;
            enable[2] <= 1'b1;
        end else if (enable[1]) begin
            count[11:8] <= count[11:8] + 1;
            enable[2] <= 1'b0;
        end else begin
            enable[2] <= 1'b0;
        end
        
        // thousands digit
        if (enable[2] && count[15:12] == 4'd9) begin
            count[15:12] <= 4'd0;
        end else if (enable[2]) begin
            count[15:12] <= count[15:12] + 1;
        end
    end
end

assign q = count;
assign ena = enable;

endmodule