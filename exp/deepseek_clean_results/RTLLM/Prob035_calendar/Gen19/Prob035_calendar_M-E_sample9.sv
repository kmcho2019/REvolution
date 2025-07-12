module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Constants
localparam SEC_MAX = 6'd59;
localparam MIN_MAX = 6'd59;
localparam HOUR_MAX = 6'd23;

// Pipeline registers
reg sec_roll_p1, min_roll_p1;
reg [5:0] sec_next, min_next;
reg [5:0] hour_next;

// Stage 1: Second calculation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_next <= 6'd0;
        sec_roll_p1 <= 1'b0;
    end else begin
        sec_next <= (Secs == SEC_MAX) ? 6'd0 : Secs + 1;
        sec_roll_p1 <= (Secs == SEC_MAX);
    end
end

// Stage 2: Minute calculation
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        min_next <= 6'd0;
        min_roll_p1 <= 1'b0;
    end else begin
        min_next <= (sec_roll_p1 && (Mins == MIN_MAX)) ? 6'd0 : 
                   (sec_roll_p1 ? Mins + 1 : Mins);
        min_roll_p1 <= (sec_roll_p1 && (Mins == MIN_MAX));
    end
end

// Stage 3: Hour calculation and update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Secs <= sec_next;
        Mins <= min_next;
        Hours <= (min_roll_p1 && (Hours == HOUR_MAX)) ? 6'd0 : 
                (min_roll_p1 ? Hours + 1 : Hours);
    end
end

endmodule