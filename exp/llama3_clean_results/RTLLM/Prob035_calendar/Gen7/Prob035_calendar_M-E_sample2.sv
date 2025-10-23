module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [5:0] sec_reg;
reg [5:0] min_reg;
reg [4:0] hour_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_reg <= 6'd0;
        min_reg <= 6'd0;
        hour_reg <= 5'd0;
    end else begin
        sec_reg <= (sec_reg == 6'd59) ? 6'd0 : sec_reg + 1'd1;
        min_reg <= (sec_reg == 6'd0 && min_reg == 6'd59) ? 6'd0 : (sec_reg == 6'd0) ? min_reg + 1'd1 : min_reg;
        hour_reg <= (min_reg == 6'd0 && sec_reg == 6'd0 && hour_reg == 5'd23) ? 5'd0 : (min_reg == 6'd0 && sec_reg == 6'd0) ? hour_reg + 1'd1 : hour_reg;
    end
end

assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = hour_reg;

endmodule