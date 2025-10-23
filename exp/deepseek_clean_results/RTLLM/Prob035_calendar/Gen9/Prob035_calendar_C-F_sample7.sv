module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Gray code conversion functions
function [5:0] bin2gray6;
    input [5:0] bin;
    begin
        bin2gray6 = {bin[5], bin[5:1] ^ bin[4:0]};
    end
endfunction

function [4:0] bin2gray5;
    input [4:0] bin;
    begin
        bin2gray5 = {bin[4], bin[4:1] ^ bin[3:0]};
    end
endfunction

// Next state values (binary for arithmetic)
reg [5:0] next_sec;
reg [5:0] next_min;
reg [4:0] next_hour;

// Rollover signals
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) && sec_rollover;
wire hour_rollover = (Hours == MAX_HOUR) && min_rollover;

// Clock gating enables
wire sec_en = 1'b1;  // Always enabled (simplest case)
wire min_en = sec_rollover;
wire hour_en = min_rollover;

always @(*) begin
    // Seconds logic
    next_sec = sec_rollover ? 6'd0 : (Secs + 6'd1);
    
    // Minutes logic
    if (min_en) begin
        next_min = min_rollover ? 6'd0 : (Mins + 6'd1);
    end else begin
        next_min = Mins;
    end
    
    // Hours logic
    if (hour_en) begin
        next_hour = hour_rollover ? 5'd0 : (Hours + 5'd1);
    end else begin
        next_hour = Hours;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset to binary 0 (Gray code also 0)
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Update with binary values (convert to Gray on outputs if needed)
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

// Optional: Convert outputs to Gray code
// assign Secs_gray = bin2gray6(Secs);
// assign Mins_gray = bin2gray6(Mins);
// assign Hours_gray = bin2gray5(Hours);

endmodule