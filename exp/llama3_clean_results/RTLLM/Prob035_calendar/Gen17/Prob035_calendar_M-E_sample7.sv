module calendar(
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [4:0] hours_reg;
reg [5:0] mins_reg;
reg [5:0] secs_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hours_reg <= 5'd0;
        mins_reg <= 6'd0;
        secs_reg <= 6'd0;
    end else begin
        if (secs_reg == 6'd59) begin
            secs_reg <= 6'd0;
            if (mins_reg == 6'd59) begin
                mins_reg <= 6'd0;
                if (hours_reg == 5'd23) begin
                    hours_reg <= 5'd0;
                end else begin
                    hours_reg <= hours_reg + 5'd1;
                end
            end else begin
                mins_reg <= mins_reg + 6'd1;
            end
        end else begin
            secs_reg <= secs_reg + 6'd1;
        end
    end
end

assign Hours = hours_reg;
assign Mins = mins_reg;
assign Secs = secs_reg;

endmodule