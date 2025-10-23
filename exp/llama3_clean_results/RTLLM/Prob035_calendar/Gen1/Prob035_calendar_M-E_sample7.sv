module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [5:0] internal_Secs;
reg [5:0] internal_Mins;
reg [5:0] internal_Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        internal_Secs <= 6'd0;
        internal_Mins <= 6'd0;
        internal_Hours <= 6'd0;
    end else begin
        if (internal_Secs == 6'd59) begin
            internal_Secs <= 6'd0;
            if (internal_Mins == 6'd59) begin
                internal_Mins <= 6'd0;
                if (internal_Hours == 6'd23) begin
                    internal_Hours <= 6'd0;
                end else begin
                    internal_Hours <= internal_Hours + 1'd1;
                end
            end else begin
                internal_Mins <= internal_Mins + 1'd1;
            end
        end else begin
            internal_Secs <= internal_Secs + 1'd1;
        end
    end
end

assign Secs = internal_Secs;
assign Mins = internal_Mins;
assign Hours = internal_Hours;

endmodule