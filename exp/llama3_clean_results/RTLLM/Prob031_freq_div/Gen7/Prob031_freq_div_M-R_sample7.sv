module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // Counter for 50MHz clock
reg [2:0] cnt_10;  // Counter for 10MHz clock
reg [5:0] cnt_100;  // Counter for 1MHz clock

// Reset counters and output clocks when RST is active
always @(posedge RST) begin
    cnt_2 <= 0;
    cnt_10 <= 0;
    cnt_100 <= 0;
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
end

// Generate CLK_50
always @(posedge CLK_in) begin
    if (!RST) begin
        // Toggle CLK_50 by inverting its current value
        CLK_50 <= ~CLK_50;
    end
end

// Generate CLK_10
always @(posedge CLK_in) begin
    if (!RST) begin
        if (cnt_10 == 4) begin
            // Toggle CLK_10 by inverting its current value and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
end

// Generate CLK_1
always @(posedge CLK_in) begin
    if (!RST) begin
        if (cnt_100 == 49) begin
            // Toggle CLK_1 by inverting its current value and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule