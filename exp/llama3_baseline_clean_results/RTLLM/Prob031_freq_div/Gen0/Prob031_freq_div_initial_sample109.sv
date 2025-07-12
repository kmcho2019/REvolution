module freq_div(
    input        CLK_in,    // Input clock signal
    input        RST,      // Reset signal
    output       CLK_50,   // Output clock signal with a frequency of CLK_in divided by 2
    output       CLK_10,   // Output clock signal with a frequency of CLK_in divided by 10
    output       CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg             CLK_50_reg;   // Internal register for CLK_50
reg             CLK_10_reg;   // Internal register for CLK_10
reg             CLK_1_reg;    // Internal register for CLK_1
reg [1:0]       cnt_2;        // Counter for CLK_50
reg [3:0]       cnt_10;       // Counter for CLK_10
reg [5:0]       cnt_100;      // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all registers and counters when RST is asserted
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        CLK_1_reg <= 1'b0;
        cnt_10 <= 4'd0;
        cnt_100 <= 6'd0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50_reg <= ~CLK_50_reg;

        // Generate CLK_10 by counting the number of input clock cycles
        if(cnt_10 == 4'd9) begin
            // Toggle CLK_10 and reset the counter when it reaches 10
            CLK_10_reg <= ~CLK_10_reg;
            cnt_10 <= 4'd0;
        end else begin
            // Increment the counter
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1 by counting the number of input clock cycles
        if(cnt_100 == 6'd49) begin
            // Toggle CLK_1 and reset the counter when it reaches 100
            CLK_1_reg <= ~CLK_1_reg;
            cnt_100 <= 6'd0;
        end else begin
            // Increment the counter
            cnt_100 <= cnt_100 + 1;
        end
    end
end

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

endmodule