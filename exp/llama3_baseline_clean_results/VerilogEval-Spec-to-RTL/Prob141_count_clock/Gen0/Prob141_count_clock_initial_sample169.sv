module TopModule(
    input  clk, 
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] h_tens;
reg [3:0] h_ones;
reg [5:0] m_tens;
reg [5:0] m_ones;
reg [5:0] s_tens;
reg [5:0] s_ones;

assign hh = {h_tens, h_ones};
assign mm = {m_tens, m_ones};
assign ss = {s_tens, s_ones};
assign pm = (h_tens == 1 && h_ones >= 2) || (h_tens == 0 && h_ones >= 12);

always @(posedge clk) begin
    if(reset) begin
        h_tens <= 0;
        h_ones <= 1;
        m_tens <= 0;
        m_ones <= 0;
        s_tens <= 0;
        s_ones <= 0;
    end else if (ena) begin
        if(s_ones == 9) begin
            s_ones <= 0;
            if(s_tens == 5) begin
                s_tens <= 0;
                if(m_ones == 9) begin
                    m_ones <= 0;
                    if(m_tens == 5) begin
                        m_tens <= 0;
                        if(h_ones == 12) begin
                            h_ones <= 1;
                            if(h_tens == 1) begin
                                h_tens <= 0;
                            end else begin
                                h_tens <= 1;
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