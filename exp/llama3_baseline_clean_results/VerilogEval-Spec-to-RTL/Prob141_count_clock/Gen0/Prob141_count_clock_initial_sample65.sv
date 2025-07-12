module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h_tens;
reg [3:0] h_units;
reg [5:0] m_tens;
reg [5:0] m_units;
reg [5:0] s_tens;
reg [5:0] s_units;
reg pm_state;

always @(posedge clk) begin
    if (reset) begin
        h_tens <= 0;
        h_units <= 0;
        m_tens <= 0;
        m_units <= 0;
        s_tens <= 0;
        s_units <= 0;
        pm_state <= 0;
    end else if (ena) begin
        // increment seconds
        if (s_units == 9 && s_tens == 5) begin
            s_tens <= 0;
            s_units <= 0;
            // increment minutes
            if (m_units == 9 && m_tens == 5) begin
                m_tens <= 0;
                m_units <= 0;
                // increment hours
                if (h_units == 9 && h_tens == 1) begin
                    h_tens <= 0;
                    h_units <= 0;
                    pm_state <= ~pm_state; // toggle AM/PM
                end else begin
                    if (h_units == 9) begin
                        h_tens <= h_tens + 1;
                        h_units <= 0;
                    end else begin
                        h_units <= h_units + 1;
                    end
                end
            end else begin
                if (m_units == 9) begin
                    m_tens <= m_tens + 1;
                    m_units <= 0;
                end else begin
                    m_units <= m_units + 1;
                end
            end
        end else begin
            if (s_units == 9) begin
                s_tens <= s_tens + 1;
                s_units <= 0;
            end else begin
                s_units <= s_units + 1;
            end
        end
    end
end

assign pm = pm_state;
assign hh = {h_tens, h_units};
assign mm = {m_tens[3:0], m_units};
assign ss = {s_tens[3:0], s_units};

endmodule