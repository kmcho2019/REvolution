module calendar(
    input         CLK,    // Clock input
    input         RST,    // Active high reset signal
    output reg [5:0] Secs, // 6-bit output representing the current seconds
    output reg [5:0] Mins, // 6-bit output representing the current minutes
    output reg [4:0] Hours // 5-bit output representing the current hours (0-23)
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Mins <= Mins;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        if ((Secs == 6'd59) && (Mins == 6'd59)) begin
            if (Hours == 5'd23) begin
                Hours <= 5'd0;
            end else begin
                Hours <= Hours + 5'd1;
            end
        end else begin
            Hours <= Hours;
        end
    end
end

endmodule