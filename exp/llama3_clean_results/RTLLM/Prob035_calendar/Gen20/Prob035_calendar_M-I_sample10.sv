module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg clk_enable;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
        clk_enable <= 1'b1;
    end else begin
        if (clk_enable) begin
            if (Secs == 6'd59) begin
                Secs <= 6'd0;
                if (Mins == 6'd59) begin
                    Mins <= 6'd0;
                    if (Hours == 5'd23) begin
                        Hours <= 5'd0;
                    end else begin
                        Hours <= Hours + 1;
                    end
                end else begin
                    Mins <= Mins + 1;
                end
            end else begin
                Secs <= Secs + 1;
            end
        end
    end
end

// Clock gating: Enable clock only when necessary
always @(posedge CLK) begin
    if (Secs == 6'd0 && Mins == 6'd0 && Hours == 5'd0) begin
        clk_enable <= 1'b0;
    end else begin
        clk_enable <= 1'b1;
    end
end

endmodule