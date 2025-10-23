module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] cnt;  // Single counter for all output clocks
reg prev_CLK_in;  // Previous value of CLK_in

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counter and previous CLK_in value
        cnt <= 0;
        prev_CLK_in <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Update previous CLK_in value
        prev_CLK_in <= CLK_in;

        // Update counter
        if(cnt == 99) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate CLK_50
        if(CLK_in && !prev_CLK_in) begin
            CLK_50 <= ~CLK_50;
        end

        // Generate CLK_10
        if(cnt == 9 || cnt == 49) begin
            CLK_10 <= ~CLK_10;
        end

        // Generate CLK_1
        if(cnt == 49) begin
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule