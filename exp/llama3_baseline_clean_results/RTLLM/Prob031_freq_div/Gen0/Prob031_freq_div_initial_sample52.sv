module freq_div(CLK_in, RST, CLK_50, CLK_10, CLK_1);
    input  CLK_in;
    input  RST;
    output CLK_50;
    output CLK_10;
    output CLK_1;

    reg     CLK_50;
    reg     CLK_10;
    reg     CLK_1;
    reg [1:0]  cnt_10;  // 2-bit counter for 10MHz clock
    reg [5:0]  cnt_100; // 6-bit counter for 1MHz clock

    always @(posedge CLK_in or posedge RST) begin
        if(RST) begin
            // Reset counters and clocks when RST is active
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 2'b00;
            cnt_100 <= 6'b00;
        end
        else begin
            // Toggle CLK_50 on every positive edge of CLK_in
            CLK_50 <= ~CLK_50;

            // Generate CLK_10
            if(cnt_10 == 4'b1000) begin
                // Toggle CLK_10 when counter reaches 4 and reset counter
                CLK_10 <= ~CLK_10;
                cnt_10 <= 2'b00;
            end
            else begin
                // Increment counter for CLK_10
                cnt_10 <= cnt_10 + 1'b1;
            end

            // Generate CLK_1
            if(cnt_100 == 6'b110001) begin
                // Toggle CLK_1 when counter reaches 49 and reset counter
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b00;
            end
            else begin
                // Increment counter for CLK_1
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule