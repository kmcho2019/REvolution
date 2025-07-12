module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= Secs + 6'd1;
        if (Secs == 6'd0) begin
            Mins <= Mins + 6'd1;
            if (Mins == 6'd0) begin
                Hours <= Hours + 5'd1;
                if (Hours == 5'd24) begin
                    Hours <= 5'd0;
                end
            end
            if (Mins == 6'd60) begin
                Mins <= 6'd0;
            end
        end
        if (Secs == 6'd60) begin
            Secs <= 6'd0;
        end
    end
end

endmodule