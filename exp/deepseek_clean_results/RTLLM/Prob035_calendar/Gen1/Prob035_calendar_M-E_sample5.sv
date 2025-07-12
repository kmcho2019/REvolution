module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Shared terminal count signals
wire sec_terminal = (Secs == 6'd59);
wire min_terminal = (Mins == 6'd59) & sec_terminal;
wire hour_terminal = (Hours == 6'd23) & min_terminal;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Synchronous reset
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Next second calculation (always increments)
        Secs <= sec_terminal ? 6'd0 : Secs + 6'd1;
        
        // Next minute calculation (only when seconds terminal)
        if (sec_terminal) begin
            Mins <= min_terminal ? 6'd0 : Mins + 6'd1;
        end
        
        // Next hour calculation (only when minutes terminal)
        if (min_terminal) begin
            Hours <= hour_terminal ? 6'd0 : Hours + 6'd1;
        end
    end
end

endmodule