module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'b0;
    end else begin
        Secs <= Secs + 1'b1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else if (Secs == 6'd0 && Secs!= 6'd59) begin
        // Do nothing
    end else if (Secs == 6'd0) begin
        if (Mins == 6'd59) begin
            Mins <= 6'b0;
        end else begin
            Mins <= Mins + 1'b1;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'b0;
    end else if (Secs == 6'd0 && Mins == 6'd0) begin
        if (Hours == 5'd23) begin
            Hours <= 5'b0;
        end else begin
            Hours <= Hours + 1'b1;
        end
    end
end

endmodule