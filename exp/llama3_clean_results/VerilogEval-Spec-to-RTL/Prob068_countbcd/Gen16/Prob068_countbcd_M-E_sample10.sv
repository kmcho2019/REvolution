module UnifiedBCDCounter(
    input  clk,
    input  reset,
    output [15:0] q
);

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        // Increment the count
        count <= count + 1'd1;
        
        // Handle carry logic for each digit
        if (count[3:0] == 4'd9) begin
            count[3:0] <= 4'd0;
            if (count[7:4] == 4'd9) begin
                count[7:4] <= 4'd0;
                if (count[11:8] == 4'd9) begin
                    count[11:8] <= 4'd0;
                    if (count[15:12] == 4'd9) begin
                        count[15:12] <= 4'd0;
                    end else begin
                        count[15:12] <= count[15:12] + 1'd1;
                    end
                end else begin
                    count[11:8] <= count[11:8] + 1'd1;
                end
            end else begin
                count[7:4] <= count[7:4] + 1'd1;
            end
        end
    end
end

assign q = count;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire [3:0] ones;
wire [3:0] tens;
wire [3:0] hundreds;
wire [3:0] thousands;

UnifiedBCDCounter counter(
    .clk(clk),
    .reset(reset),
    .q(q)
);

assign ones = q[3:0];
assign tens = q[7:4];
assign hundreds = q[11:8];
assign thousands = q[15:12];

// Generate enable signals for each digit
assign ena[0] = (ones == 4'd9) ? 1'b1 : 1'b0;
assign ena[1] = (tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;
assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) ? 1'b1 : 1'b0;

endmodule