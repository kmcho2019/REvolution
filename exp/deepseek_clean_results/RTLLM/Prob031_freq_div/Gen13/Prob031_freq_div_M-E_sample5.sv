module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Single shared counter (0-99)
    reg [6:0] master_cnt;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            master_cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update master counter (modulo 100)
            master_cnt <= (master_cnt == 7'd99) ? 7'd0 : master_cnt + 7'd1;
            
            // CLK_50 (toggle every 50 cycles = 50MHz)
            if (master_cnt[0] == 1'b1)  // Check LSB for /2
                CLK_50 <= ~CLK_50;
            
            // CLK_10 (toggle every 5th toggle of CLK_50)
            if (master_cnt == 7'd4 || master_cnt == 7'd9 || 
                master_cnt == 7'd14 || master_cnt == 7'd19 ||
                master_cnt == 7'd24 || master_cnt == 7'd29 ||
                master_cnt == 7'd34 || master_cnt == 7'd39 ||
                master_cnt == 7'd44 || master_cnt == 7'd49 ||
                master_cnt == 7'd54 || master_cnt == 7'd59 ||
                master_cnt == 7'd64 || master_cnt == 7'd69 ||
                master_cnt == 7'd74 || master_cnt == 7'd79 ||
                master_cnt == 7'd84 || master_cnt == 7'd89 ||
                master_cnt == 7'd94 || master_cnt == 7'd99)
                CLK_10 <= ~CLK_10;
            
            // CLK_1 (toggle at mid-point of full cycle)
            if (master_cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule