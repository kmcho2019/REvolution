module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] ena_int;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        ena_int <= 3'b000;
    end else begin
        if (count[3:0] == 4'd9) begin
            count[3:0] <= 4'd0;
            ena_int[0] <= 1'b1;
        end else begin
            count[3:0] <= count[3:0] + 1'b1;
            ena_int[0] <= 1'b0;
        end

        if (count[7:4] == 4'd9 && ena_int[0]) begin
            count[7:4] <= 4'd0;
            ena_int[1] <= 1'b1;
        end else if (ena_int[0]) begin
            count[7:4] <= count[7:4] + 1'b1;
            ena_int[1] <= 1'b0;
        end else begin
            ena_int[1] <= 1'b0;
        end

        if (count[11:8] == 4'd9 && ena_int[1]) begin
            count[11:8] <= 4'd0;
            ena_int[2] <= 1'b1;
        end else if (ena_int[1]) begin
            count[11:8] <= count[11:8] + 1'b1;
            ena_int[2] <= 1'b0;
        end else begin
            ena_int[2] <= 1'b0;
        end

        if (count[15:12] == 4'd9 && ena_int[2]) begin
            count[15:12] <= 4'd0;
        end else if (ena_int[2]) begin
            count[15:12] <= count[15:12] + 1'b1;
        end
    end
end

assign q = count;
assign ena = ena_int;

endmodule