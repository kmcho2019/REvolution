module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

// Always block to handle reset
always @(posedge RST) begin
    Secs <= 6'b0;
    Mins <= 6'b0;
    Hours <= 5'b0;
end

// Always block to update seconds
always @(posedge CLK) begin
    if (!RST) begin
        if (Secs == 6'd59) begin
            Secs <= 6'b0;
        end else begin
            Secs <= Secs + 1'b1;
        end
    end
end

// Always block to update minutes
always @(posedge CLK) begin
    if (!RST) begin
        if (Secs == 6'd0 && Secs != 6'd59) begin
            // Do nothing
        end else if (Secs == 6'd0 && Secs == 6'd59) begin
            if (Mins == 6'd59) begin
                Mins <= 6'b0;
            end else begin
                Mins <= Mins + 1'b1;
            end
        end
    end
end

// Always block to update hours
always @(posedge CLK) begin
    if (!RST) begin
        if (Mins == 6'd0 && Mins != 6'd59 && Secs == 6'd0) begin
            // Do nothing
        end else if (Mins == 6'd0 && Mins == 6'd59 && Secs == 6'd0) begin
            if (Hours == 5'd23) begin
                Hours <= 5'b0;
            end else begin
                Hours <= Hours + 1'b1;
            end
        end
    end
end

endmodule