module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SECS = 6'd59;
localparam MAX_MINS = 6'd59;
localparam MAX_HOURS = 6'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Handle seconds increment and rollover
        Secs <= (Secs == MAX_SECS) ? 6'd0 : Secs + 6'd1;
        
        // Handle minutes increment only when needed
        if (Secs == MAX_SECS) begin
            Mins <= (Mins == MAX_MINS) ? 6'd0 : Mins + 6'd1;
            
            // Handle hours increment only when needed
            if (Mins == MAX_MINS) begin
                Hours <= (Hours == MAX_HOURS) ? 6'd0 : Hours + 6'd1;
            end
        end
    end
end

endmodule