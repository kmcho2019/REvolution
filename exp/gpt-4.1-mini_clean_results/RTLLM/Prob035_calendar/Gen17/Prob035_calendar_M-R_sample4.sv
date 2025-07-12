module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 range, needs 5 bits
    output reg  [5:0] Mins,  // 0-59 range
    output reg  [5:0] Secs   // 0-59 range
);

    // Carry signals between counters
    wire secs_carry;
    wire mins_carry;

    // Seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 6'd0;
            end else begin
                Secs <= Secs + 6'd1;
            end
        end
    end

    assign secs_carry = (Secs == 6'd59);

    // Minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (secs_carry) begin
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end
    end

    assign mins_carry = secs_carry && (Mins == 6'd59);

    // Hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 5'd0;
        end else if (mins_carry) begin
            if (Hours == 5'd23) begin
                Hours <= 5'd0;
            end else begin
                Hours <= Hours + 5'd1;
            end
        end
    end

endmodule