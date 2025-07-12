module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23: 5 bits
    output reg  [5:0] Mins,  // 0-59: 6 bits
    output reg  [5:0] Secs   // 0-59: 6 bits
);

// Increment seconds every clock cycle
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

// Increment minutes only when seconds roll over from 59 to 0
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else begin
        if (Secs == 6'd59) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
    end
end

// Increment hours only when minutes and seconds both roll over from 59 to 0 simultaneously
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else begin
        if ((Mins == 6'd59) && (Secs == 6'd59)) begin
            if (Hours == 5'd23)
                Hours <= 5'd0;
            else
                Hours <= Hours + 5'd1;
        end
    end
end

endmodule