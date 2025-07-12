module calendar #
(
    parameter int SECS_WIDTH = 6,
    parameter int MINS_WIDTH = 6,
    parameter int HOURS_WIDTH = 5
)
(
    input CLK,
    input RST,
    output reg [SECS_WIDTH-1:0] Secs,
    output reg [MINS_WIDTH-1:0] Mins,
    output reg [HOURS_WIDTH-1:0] Hours
);

reg [SECS_WIDTH-1:0] secs_reg;
reg [MINS_WIDTH-1:0] mins_reg;
reg [HOURS_WIDTH-1:0] hours_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_reg <= 'd0;
        mins_reg <= 'd0;
        hours_reg <= 'd0;
    end else begin
        if (secs_reg == {SECS_WIDTH{1'b1}} - 1) begin
            secs_reg <= 'd0;
            if (mins_reg == {MINS_WIDTH{1'b1}} - 1) begin
                mins_reg <= 'd0;
                if (hours_reg == {HOURS_WIDTH{1'b1}} - 1) begin
                    hours_reg <= 'd0;
                end else begin
                    hours_reg <= hours_reg + 1'b1;
                end
            end else begin
                mins_reg <= mins_reg + 1'b1;
            end
        end else begin
            secs_reg <= secs_reg + 1'b1;
        end
    end
end

assign Secs = secs_reg;
assign Mins = mins_reg;
assign Hours = hours_reg;

endmodule