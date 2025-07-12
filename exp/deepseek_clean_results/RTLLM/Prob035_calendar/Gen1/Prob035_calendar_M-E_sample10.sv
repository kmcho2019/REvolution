module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [16:0] master_counter; // 17 bits for 0-86399 (24*60*60-1)

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        master_counter <= 17'd0;
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Increment master counter with automatic rollover
        master_counter <= (master_counter == 17'd86399) ? 17'd0 : master_counter + 17'd1;
        
        // Calculate seconds: mod 60
        Secs <= master_counter % 6'd60;
        
        // Calculate minutes: (counter/60) mod 60
        Mins <= (master_counter / 6'd60) % 6'd60;
        
        // Calculate hours: counter/3600
        Hours <= master_counter / 17'd3600;
    end
end

endmodule