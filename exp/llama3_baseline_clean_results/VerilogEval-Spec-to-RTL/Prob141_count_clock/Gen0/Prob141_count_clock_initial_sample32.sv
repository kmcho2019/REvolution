module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// BCD counters for hours, minutes, and seconds
reg [3:0] h_tens;
reg [3:0] h_ones;
reg [3:0] m_tens;
reg [3:0] m_ones;
reg [3:0] s_tens;
reg [3:0] s_ones;

// Assign outputs to counters
assign hh = {h_tens, h_ones};
assign mm = {m_tens, m_ones};
assign ss = {s_tens, s_ones};

// Reset the counters to the initial state
always @(posedge clk) begin
    if (reset) begin
        h_tens <= 0;
        h_ones <= 2; // initial hour is 12
        m_tens <= 0;
        m_ones <= 0; // initial minute is 0
        s_tens <= 0;
        s_ones <= 0; // initial second is 0
        pm <= 0; // initial time is AM
    end else if (ena) begin
        // Increment the seconds counter
        if (s_ones == 9) begin
            s_ones <= 0;
            if (s_tens == 5) begin
                s_tens <= 0;
                // Increment the minutes counter
                if (m_ones == 9) begin
                    m_ones <= 0;
                    if (m_tens == 5) begin
                        m_tens <= 0;
                        // Increment the hours counter
                        if (h_ones == 2 && h_tens == 1) begin // 12 PM
                            h_ones <= 1;
                            h_tens <= 0;
                            pm <= 0; // switch to AM
                        end else if (h_ones == 2 && h_tens == 0) begin // 12 AM
                            h_ones <= 1;
                            h_tens <= 0;
                            pm <= 1; // switch to PM
                        end else if (h_ones == 9) begin
                            h_ones <= 0;
                            if (h_tens == 1) begin // 12 -> 1
                                h_tens <= 0;
                            end else begin
                                h_tens <= h_tens + 1;
                            end
                        end else begin
                            h_ones <= h_ones + 1;
                        end
                    end else begin
                        m_tens <= m_tens + 1;
                    end
                end else begin
                    m_ones <= m_ones + 1;
                end
            end else begin
                s_tens <= s_tens + 1;
            end
        end else begin
            s_ones <= s_ones + 1;
        end
    end
end

endmodule