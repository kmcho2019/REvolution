module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 6'd23);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds update
        if (sec_max) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end

        // Minutes update only when seconds roll over
        if (sec_max) begin
            if (min_max) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end

        // Hours update only when minutes and seconds roll over
        if (sec_max && min_max) begin
            if (hour_max) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
    end
end

endmodule