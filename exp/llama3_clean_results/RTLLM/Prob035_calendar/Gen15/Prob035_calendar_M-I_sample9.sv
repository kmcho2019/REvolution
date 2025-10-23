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
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                if (Hours == 5'd23) begin
                    Hours <= 5'd0;
                end else begin
                    Hours <= Hours + 1'd1;
                end
            end else begin
                Mins <= Mins + 1'd1;
            end
        end else begin
            Secs <= Secs + 1'd1;
        end
    end
end

endmodule