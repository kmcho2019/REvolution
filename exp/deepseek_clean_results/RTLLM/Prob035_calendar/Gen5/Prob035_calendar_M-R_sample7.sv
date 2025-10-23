module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

// Internal registers
reg [5:0] sec_reg;  // 0-59
reg [5:0] min_reg;  // 0-59
reg [4:0] hour_reg; // 0-23

// Terminal counts
localparam SEC_MAX = 6'd59;
localparam MIN_MAX = 6'd59;
localparam HOUR_MAX = 5'd23;

// Single always block for all counters
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_reg <= 0;
        min_reg <= 0;
        hour_reg <= 0;
    end else begin
        // Seconds counter
        if (sec_reg == SEC_MAX) begin
            sec_reg <= 0;
            // Minutes counter
            if (min_reg == MIN_MAX) begin
                min_reg <= 0;
                // Hours counter
                if (hour_reg == HOUR_MAX)
                    hour_reg <= 0;
                else
                    hour_reg <= hour_reg + 1;
            end else begin
                min_reg <= min_reg + 1;
            end
        end else begin
            sec_reg <= sec_reg + 1;
        end
    end
end

// Output assignments
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = {1'b0, hour_reg}; // Zero-extend to 6 bits

endmodule