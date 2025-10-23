module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // Changed to 6-bit as requested
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    // Seconds counter
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

    // Minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else begin
            // Increment minutes only when seconds wrap from 59 to 0
            if ((Secs == 6'd59)) begin
                if (Mins == 6'd59)
                    Mins <= 6'd0;
                else
                    Mins <= Mins + 6'd1;
            end
            // else keep Mins unchanged implicitly
        end
    end

    // Hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else begin
            // Increment hours only when minutes and seconds wrap
            if ((Mins == 6'd59) && (Secs == 6'd59)) begin
                if (Hours == 6'd23)
                    Hours <= 6'd0;
                else
                    Hours <= Hours + 6'd1;
            end
            // else keep Hours unchanged implicitly
        end
    end

endmodule