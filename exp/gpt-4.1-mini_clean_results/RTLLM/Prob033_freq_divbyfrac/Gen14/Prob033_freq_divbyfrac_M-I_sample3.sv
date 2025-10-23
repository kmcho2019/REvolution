module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // 3.5 = 7/2: count modulo 7 on each clock edge (pos and neg)
    reg [2:0] cnt;

    // This process triggers on both edges of clk to count edges
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            // Increment modulo 7 counter at each clk edge
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div at specific cnt values depending on clk edge type
            // When clk is high (posedge): toggle at cnt==0 or cnt==4
            // When clk is low  (negedge): toggle at cnt==2 or cnt==6

            if (clk) begin
                // posedge actions
                if ((cnt == 3'd0) || (cnt == 3'd4))
                    clk_div <= ~clk_div;
            end else begin
                // negedge actions
                if ((cnt == 3'd2) || (cnt == 3'd6))
                    clk_div <= ~clk_div;
            end
        end
    end

endmodule