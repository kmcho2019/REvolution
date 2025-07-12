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
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd0 && Secs == 6'd0) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins;
        end
    end else if (Secs == 6'd0) begin
        Mins <= Mins + 6'd1;
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (Mins == 6'd0 && Secs == 6'd0) begin
        if (Hours == 5'd23) begin
            Hours <= 5'd0;
        end else begin
            Hours <= Hours;
        end
    end else if (Mins == 6'd0) begin
        Hours <= Hours + 5'd1;
    end else begin
        Hours <= Hours;
    end
end

endmodule