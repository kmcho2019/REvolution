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
        sec_reg <= 6'b0;
        min_reg <= 6'b0;
        hour_reg <= 5'b0;
    end else begin
        if (sec_reg == 6'd59) begin
            sec_reg <= 6'b0;
            if (min_reg == 6'd59) begin
                min_reg <= 6'b0;
                if (hour_reg == 5'd23) begin
                    hour_reg <= 5'b0;
                end else begin
                    hour_reg <= hour_reg + 1'b1;
                end
            end else begin
                min_reg <= min_reg + 1'b1;
            end
        end else begin
            sec_reg <= sec_reg + 1'b1;
        end
    end
end

assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = hour_reg;

endmodule