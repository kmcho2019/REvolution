module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray-coded counter [6:0] counts 0-99
    reg [6:0] counter_gray;
    wire [6:0] next_counter_gray;
    wire [6:0] counter_binary;
    
    // Gray to binary conversion
    assign counter_binary[6] = counter_gray[6];
    assign counter_binary[5] = counter_binary[6] ^ counter_gray[5];
    assign counter_binary[4] = counter_binary[5] ^ counter_gray[4];
    assign counter_binary[3] = counter_binary[4] ^ counter_gray[3];
    assign counter_binary[2] = counter_binary[3] ^ counter_gray[2];
    assign counter_binary[1] = counter_binary[2] ^ counter_gray[1];
    assign counter_binary[0] = counter_binary[1] ^ counter_gray[0];
    
    // Binary to Gray conversion for next value
    assign next_counter_gray = ((counter_binary == 7'd99) ? 7'd0 : (counter_binary + 7'd1)) ^ 
                             ((counter_binary == 7'd99) ? 7'd0 : (counter_binary + 7'd1)) >> 1;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter_gray <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end
        else begin
            counter_gray <= next_counter_gray;
            
            // CLK_50 - toggle every cycle (but use enable for better glitch control)
            if (counter_binary[0] == 1'b1) begin
                CLK_50 <= ~CLK_50;
            end
            
            // CLK_10 - update at counter=4,14,24,...94 (every 10 cycles)
            if (counter_binary[3:0] == 4'd4) begin
                CLK_10 <= ~CLK_10;
            end
            
            // CLK_1 - update at counter=49,99
            if (counter_binary == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule