module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

// Define counter sizes explicitly
reg [1:0] cnt_50;  // Counter for CLK_50 (divide by 2)
reg [3:0] cnt_10;  // Counter for CLK_10 (divide by 10)
reg [6:0] cnt_100;  // Counter for CLK_1 (divide by 100)

// Handle reset
always @(posedge RST) begin
    // Reset counters and output clocks
    cnt_50 <= 0;
    cnt_10 <= 0;
    cnt_100 <= 0;
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
end

// Increment counters
always @(posedge CLK_in) begin
    if (!RST) begin
        // Increment counter for CLK_50
        if (cnt_50 == 1) begin
            cnt_50 <= 0;
        end else begin
            cnt_50 <= cnt_50 + 1;
        end
        
        // Increment counter for CLK_10
        if (cnt_10 == 9) begin
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Increment counter for CLK_1
        if (cnt_100 == 99) begin
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

// Generate output clocks
assign CLK_50 = (cnt_50 == 1) ? 1'b1 : 1'b0;
assign CLK_10 = (cnt_10 == 9) ? 1'b1 : 1'b0;
assign CLK_1 = (cnt_100 == 99) ? 1'b1 : 1'b0;

endmodule