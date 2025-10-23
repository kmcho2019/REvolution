module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [5:0] secs_reg;
reg [5:0] mins_reg;
reg [4:0] hours_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_reg <= 6'b0;
        mins_reg <= 6'b0;
        hours_reg <= 5'b0;
    end else begin
        if (secs_reg == 6'd59) begin
            secs_reg <= 6'b0;
            if (mins_reg == 6'd59) begin
                mins_reg <= 6'b0;
                if (hours_reg == 5'd23) begin
                    hours_reg <= 5'b0;
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

always @(*) begin
    Secs = secs_reg;
    Mins = mins_reg;
    Hours = hours_reg;
end

endmodule