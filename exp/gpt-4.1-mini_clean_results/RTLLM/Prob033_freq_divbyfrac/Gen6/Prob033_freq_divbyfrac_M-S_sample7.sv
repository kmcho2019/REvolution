module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    reg [2:0] cnt;

    reg clk_int;          // toggled on posedge clk at cnt=0 or 4
    reg clk_int_delayed;  // toggled on negedge clk at cnt=3 or 6

    // Counter and clk_int toggle on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 3'd0;
            clk_int <= 1'b0;
        end else begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            if (cnt == 3'd0 || cnt == 3'd4)
                clk_int <= ~clk_int;
        end
    end

    // clk_int_delayed toggled on negative edge, shifted half clk period
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_int_delayed <= 1'b0;
        end else begin
            if (cnt == 3'd3 || cnt == 3'd6)
                clk_int_delayed <= ~clk_int_delayed;
        end
    end

    // Final output is OR of the two phase shifted clocks
    assign clk_div = clk_int | clk_int_delayed;

endmodule