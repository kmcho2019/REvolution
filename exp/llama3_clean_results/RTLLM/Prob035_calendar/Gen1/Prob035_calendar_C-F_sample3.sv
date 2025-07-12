module calendar(
    input           CLK,    // Clock input
    input           RST,    // Active high reset signal
    output reg [5:0] Hours, // 6-bit output representing the current hours
    output reg [5:0] Mins,  // 6-bit output representing the current minutes
    output reg [5:0] Secs   // 6-bit output representing the current seconds
);

// Seconds always block with optimization for reduced switching activity
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 1'd1;
    end
end

// Minutes always block with optimized logic for reduced combinational complexity
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        Mins <= (Mins == 6'd59) ? 6'd0 : Mins + 1'd1;
    end else begin
        Mins <= Mins;
    end
end

// Hours always block with conditionally updated hours for reduced switching activity
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= (Hours == 6'd23) ? 6'd0 : Hours + 1'd1;
    end else begin
        Hours <= Hours;
    end
end

endmodule