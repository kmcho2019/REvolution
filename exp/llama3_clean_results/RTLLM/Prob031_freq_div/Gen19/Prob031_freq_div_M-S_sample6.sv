module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // 7-bit counter for handling divisions

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        counter <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        if(counter < 99) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
        // For CLK_50, toggle on every other clock cycle (divide by 2)
        if(counter[0] == 1'b0) begin
            CLK_50 <= ~CLK_50;
        end
        // For CLK_10, toggle when counter reaches 9 (divide by 10)
        if(counter == 7'd9) begin
            CLK_10 <= ~CLK_10;
        end
        // For CLK_1, toggle when counter reaches 99 (divide by 100)
        if(counter == 7'd99) begin
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule