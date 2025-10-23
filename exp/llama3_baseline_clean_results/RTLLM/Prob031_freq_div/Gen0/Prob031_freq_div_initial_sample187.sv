module freq_div (
    input        CLK_in,    // Input clock signal
    input        RST,       // Reset signal
    output       CLK_50,    // Output clock signal with a frequency of CLK_in divided by 2
    output       CLK_10,    // Output clock signal with a frequency of CLK_in divided by 10
    output       CLK_1      // Output clock signal with a frequency of CLK_in divided by 100
);

reg     CLK_50_reg;     // Register to hold the value of CLK_50
reg     CLK_10_reg;     // Register to hold the value of CLK_10
reg     CLK_1_reg;      // Register to hold the value of CLK_1
reg [1:0] cnt_2;        // Counter to divide the clock by 2
reg [3:0] cnt_10;        // Counter to divide the clock by 10
reg [5:0] cnt_100;      // Counter to divide the clock by 100

// Assign the output ports to the registers
assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

// Always block to handle the clock edges and reset
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset the counters and output clock signals
        CLK_50_reg <= 0;
        CLK_10_reg <= 0;
        CLK_1_reg <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50_reg <= ~CLK_50_reg;
        
        // Increment cnt_2 on every positive edge of CLK_in
        cnt_2 <= cnt_2 + 1;
        
        // Toggle CLK_10 when cnt_10 reaches 4
        if (cnt_10 == 4'd9) begin
            CLK_10_reg <= ~CLK_10_reg;
            cnt_10 <= 0;
        end else begin
            // Increment cnt_10 on every positive edge of CLK_in
            cnt_10 <= cnt_10 + 1;
        end
        
        // Toggle CLK_1 when cnt_100 reaches 49
        if (cnt_100 == 6'd49) begin
            CLK_1_reg <= ~CLK_1_reg;
            cnt_100 <= 0;
        end else begin
            // Increment cnt_100 on every positive edge of CLK_in
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule