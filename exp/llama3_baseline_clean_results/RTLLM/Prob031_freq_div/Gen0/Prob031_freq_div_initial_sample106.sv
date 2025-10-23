module freq_div(
    input  wire  CLK_in, // Input clock signal
    input  wire  RST,    // Reset signal
    output reg   CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg   CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg   CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
    );

reg [4:0] cnt_10; // counter for CLK_10
reg [6:0] cnt_100; // counter for CLK_1

always @ (posedge CLK_in or posedge RST)
begin
    if (RST) 
    begin
        // Reset all signals when RST is high
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end 
    else 
    begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if (cnt_10 == 9) 
        begin
            // Invert CLK_10 when cnt_10 reaches 9
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end 
        else 
        begin
            // Increment cnt_10
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1
        if (cnt_100 == 99) 
        begin
            // Invert CLK_1 when cnt_100 reaches 99
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end 
        else 
        begin
            // Increment cnt_100
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule