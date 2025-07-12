module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] enable;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
        enable <= 3'b0;
    end else begin
        // Increment ones digit
        if (count[3:0] != 4'd9) begin
            count[3:0] <= count[3:0] + 1'b1;
        end else begin
            count[3:0] <= 4'b0;
            // Enable tens digit increment
            enable[0] <= 1'b1;
        end

        // Increment tens digit
        if (count[7:4] != 4'd9 || count[3:0] != 4'b0) begin
            enable[0] <= 1'b0;
        end else begin
            count[7:4] <= count[7:4] + 1'b1;
            enable[0] <= 1'b0;
            // Enable hundreds digit increment
            enable[1] <= 1'b1;
        end

        // Increment hundreds digit
        if (count[11:8] != 4'd9 || count[7:4] != 4'b0) begin
            enable[1] <= 1'b0;
        end else begin
            count[11:8] <= count[11:8] + 1'b1;
            enable[1] <= 1'b0;
            // Enable thousands digit increment
            enable[2] <= 1'b1;
        end

        // Increment thousands digit
        if (count[15:12] != 4'd9 || count[11:8] != 4'b0) begin
            enable[2] <= 1'b0;
        end else begin
            count[15:12] <= 4'b0;
            enable[2] <= 1'b0;
        end
    end
end

assign q = count;
assign ena = enable;

endmodule