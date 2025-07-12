module calendar (
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [5:0] next_Secs;
reg [5:0] next_Mins;
reg [4:0] next_Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= next_Secs;
        Mins <= next_Mins;
        Hours <= next_Hours;
    end
end

always @(*) begin
    next_Secs = Secs;
    next_Mins = Mins;
    next_Hours = Hours;
    
    if (Secs == 6'd59) begin
        next_Secs = 6'd0;
        if (Mins == 6'd59) begin
            next_Mins = 6'd0;
            if (Hours == 5'd23) begin
                next_Hours = 5'd0;
            end else begin
                next_Hours = Hours + 1'b1;
            end
        end else begin
            next_Mins = Mins + 1'b1;
        end
    end else begin
        next_Secs = Secs + 1'b1;
    end
end

endmodule