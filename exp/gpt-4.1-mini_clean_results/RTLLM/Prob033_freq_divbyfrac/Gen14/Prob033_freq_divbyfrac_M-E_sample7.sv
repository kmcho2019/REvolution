module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 3-bit counter counting 0..6 on every clock edge (posedge and negedge)
    reg [2:0] cnt;

    // Counter increments on both posedge and negedge of clk
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div <= 1'b1;  // Start clk_div high (can be 0 or 1, chosen here as 1)
        end else begin
            // Increment modulo 7
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_div is high for counts 0..3 (4 half cycles), low for 4..6 (3 half cycles)
            clk_div <= (cnt < 3'd4) ? 1'b1 : 1'b0;
        end
    end

endmodule