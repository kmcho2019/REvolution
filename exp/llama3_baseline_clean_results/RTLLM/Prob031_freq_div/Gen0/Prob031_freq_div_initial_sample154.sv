module freq_div(
    input CLK_in, // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50, // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10, // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1  // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2; // Counter for 50MHz clock generation
reg [2:0] cnt_10; // Counter for 10MHz clock generation
reg [5:0] cnt_100; // Counter for 1MHz clock generation

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b000;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        // Generate 50MHz clock
        CLK_50 <= ~CLK_50;
        
        // Generate 10MHz clock
        if(cnt_10 == 4'b0100) begin
            cnt_10 <= 3'b000;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // Generate 1MHz clock
        if(cnt_100 == 6'b110001) begin
            cnt_100 <= 6'b000000;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule