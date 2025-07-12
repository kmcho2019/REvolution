module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal signals
reg [3:0] h1, h2; // Hours (1-12)
reg [3:0] m1, m2; // Minutes (0-59)
reg [3:0] s1, s2; // Seconds (0-59)

// Initialize counters
initial begin
    h1 = 0;
    h2 = 0;
    m1 = 0;
    m2 = 0;
    s1 = 0;
    s2 = 0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset counters to initial values
        h1 <= 0;
        h2 <= 1; // 12:00 AM
        m1 <= 0;
        m2 <= 0;
        s1 <= 0;
        s2 <= 0;
    end else if (ena) begin
        // Increment seconds counter
        if (s2 == 5 && s1 == 9) begin
            s1 <= 0;
            s2 <= 0;
            // Increment minutes counter
            if (m2 == 5 && m1 == 9) begin
                m1 <= 0;
                m2 <= 0;
                // Increment hours counter
                if (h2 == 1 && h1 == 2) begin
                    h1 <= 0;
                    h2 <= 1; // 12:00 AM
                end else if (h2 == 0 && h1 == 9) begin
                    h1 <= 0;
                    h2 <= 1; // 1:00 PM
                end else if (h2 == 1 && h1 == 1) begin
                    h1 <= 0;
                    h2 <= 0; // 1:00 AM
                end else begin
                    h1 <= h1 + 1;
                end
            end else if (m2 == 5 && m1 < 9) begin
                m1 <= m1 + 1;
            end else begin
                m2 <= m2 + 1;
            end
        end else if (s2 < 5 && s1 == 9) begin
            s1 <= 0;
            s2 <= s2 + 1;
        end else begin
            s1 <= s1 + 1;
        end
    end
end

// Combinational logic
assign hh = {4'h1, h1, 4'h0, h2}; // 01-12
assign mm = {4'h0, m1, 4'h0, m2}; // 00-59
assign ss = {4'h0, s1, 4'h0, s2}; // 00-59

// PM indicator
assign pm = (h2 == 1 && h1 > 2) || (h2 == 1 && h1 == 2 && h1 == 2);

endmodule