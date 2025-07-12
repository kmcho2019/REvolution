module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Define constants for maximum values
parameter MAX_SEC = 6'd59;
parameter MAX_MIN = 6'd59;
parameter MAX_HOUR = 6'd23;

// Internal carry signals
reg sec_carry;
reg min_carry;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters and carries
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        sec_carry <= 1'b0;
        min_carry <= 1'b0;
    end else begin
        // Pipeline stage 1: Second counter with carry generation
        if (Secs == MAX_SEC) begin
            Secs <= 6'd0;
            sec_carry <= 1'b1;
        end else begin
            Secs <= Secs + 6'd1;
            sec_carry <= 1'b0;
        end

        // Pipeline stage 2: Minute counter with carry generation
        if (sec_carry) begin
            if (Mins == MAX_MIN) begin
                Mins <= 6'd0;
                min_carry <= 1'b1;
            end else begin
                Mins <= Mins + 6'd1;
                min_carry <= 1'b0;
            end
        end

        // Pipeline stage 3: Hour counter
        if (min_carry && sec_carry) begin
            if (Hours == MAX_HOUR) begin
                Hours <= 6'd0;
            end else begin
                Hours <= Hours + 6'd1;
            end
        end
    end
end

endmodule