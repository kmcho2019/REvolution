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
        // Ones digit
        if (count[3:0] == 9) begin
            count[3:0] <= 4'd0;
            enable[0] <= 1'b1;
        end else begin
            enable[0] <= 1'b0;
        end

        // Tens digit
        if (count[7:4] == 9 && enable[0]) begin
            count[7:4] <= 4'd0;
            enable[1] <= 1'b1;
        end else begin
            enable[1] <= 1'b0;
        end

        // Hundreds digit
        if (count[11:8] == 9 && enable[1]) begin
            count[11:8] <= 4'd0;
            enable[2] <= 1'b1;
        end else begin
            enable[2] <= 1'b0;
        end

        // Thousands digit
        if (count[15:12] == 9 && enable[2]) begin
            count[15:12] <= 4'd0;
        end

        // Increment the count
        if (enable[0] || enable[1] || enable[2] || (count[3:0]!= 9)) begin
            count <= count + 1;
        end
    end
end

assign ena = enable;
assign q = count;

endmodule