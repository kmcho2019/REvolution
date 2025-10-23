module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] sec_counter;
reg [5:0] min_counter;
reg [4:0] hour_counter;  // Only needs 5 bits for 0-23

wire sec_rollover = (sec_counter == 6'd59);
wire min_rollover = (min_counter == 6'd59);
wire hour_rollover = (hour_counter == 5'd23);

wire min_enable = sec_rollover;
wire hour_enable = sec_rollover & min_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_counter <= 6'd0;
    end else begin
        if (sec_rollover)
            sec_counter <= 6'd0;
        else
            sec_counter <= sec_counter + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        min_counter <= 6'd0;
    end else if (min_enable) begin
        if (min_rollover)
            min_counter <= 6'd0;
        else
            min_counter <= min_counter + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hour_counter <= 5'd0;
    end else if (hour_enable) begin
        if (hour_rollover)
            hour_counter <= 5'd0;
        else
            hour_counter <= hour_counter + 5'd1;
    end
end

// Output assignments
assign Secs = sec_counter;
assign Mins = min_counter;
assign Hours = {1'b0, hour_counter};  // Zero-extend to 6 bits

endmodule