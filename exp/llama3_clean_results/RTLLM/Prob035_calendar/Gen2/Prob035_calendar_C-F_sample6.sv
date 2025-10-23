module calendar (
    input           CLK,    // Clock input
    input           RST,    // Active high reset signal
    output reg [5:0] Hours, // 6-bit output representing the current hours
    output reg [5:0] Mins,  // 6-bit output representing the current minutes
    output reg [5:0] Secs   // 6-bit output representing the current seconds
);

reg [5:0] next_Secs;
reg [5:0] next_Mins;
reg [5:0] next_Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        next_Secs = Secs + 1'd1;
        next_Mins = Mins;
        next_Hours = Hours;

        if (Secs == 6'd59) begin
            next_Secs = 6'd0;
            next_Mins = Mins + 1'd1;
            if (Mins == 6'd59) begin
                next_Mins = 6'd0;
                next_Hours = Hours + 1'd1;
                if (Hours == 6'd23) begin
                    next_Hours = 6'd0;
                end
            end
        end

        Secs <= next_Secs;
        Mins <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule