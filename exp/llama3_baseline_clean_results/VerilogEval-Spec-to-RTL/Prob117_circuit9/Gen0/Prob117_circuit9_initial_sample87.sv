module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg = 4; // Assuming initial value based on waveform when a=1

always @(posedge clk) begin
    if (~a) begin // When a is 0, increment q
        q_reg <= q_reg + 1;
        if (q_reg == 7) // Wrap around observed in waveform
            q_reg <= 0;
    end
    else begin // When a is 1, keep q as is
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule