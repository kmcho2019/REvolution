module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] up_cnt = 0;
    reg [7:0] down_cnt = 0;
    wire up_terminal = (up_cnt == freq);
    wire down_terminal = (down_cnt == 0);

    always @(posedge clk) begin
        // Up counter logic
        if (up_terminal) begin
            up_cnt <= 0;
        end else begin
            up_cnt <= up_cnt + 1;
        end

        // Down counter logic
        if (down_terminal) begin
            down_cnt <= freq;
        end else begin
            down_cnt <= down_cnt - 1;
        end

        // Output generation
        wave_out <= up_terminal ^ down_terminal;
    end

endmodule