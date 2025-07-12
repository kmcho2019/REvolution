module freq_div (
    input CLK_in,
    input RST,
    input EN,         // Global enable
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Gray-coded counters for power optimization
    reg [1:0] cnt_2;    // For 50MHz (divide by 2)
    reg [3:0] cnt_5;    // For 10MHz (divide by 5 from 50MHz)
    reg [6:0] cnt_10;   // For 1MHz (divide by 10 from 10MHz)
    
    // Clock phase alignment registers
    reg phase_align_10;
    reg phase_align_1;
    
    // Generate 50MHz clock (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_2 <= 2'b00;
        end else if (EN) begin
            cnt_2 <= {cnt_2[0], ~cnt_2[1]}; // Gray code sequence
        end
    end
    
    assign CLK_50 = cnt_2[1];
    
    // Generate 10MHz clock (divide by 5 from 50MHz)
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_5 <= 4'b0000;
            phase_align_10 <= 1'b0;
        end else if (EN) begin
            if (cnt_5 == 4'b0100) begin // Gray code for 4
                cnt_5 <= 4'b0000;
                phase_align_10 <= 1'b1;
            end else begin
                cnt_5 <= {cnt_5[2:0], ~cnt_5[3]}; // Gray code increment
                phase_align_10 <= 1'b0;
            end
        end
    end
    
    // Synchronize 10MHz with input clock domain
    reg [1:0] sync_10;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            sync_10 <= 2'b00;
        end else begin
            sync_10 <= {sync_10[0], phase_align_10};
        end
    end
    
    assign CLK_10 = sync_10[1];
    
    // Generate 1MHz clock (divide by 10 from 10MHz)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_10 <= 7'b0000000;
            phase_align_1 <= 1'b0;
        end else if (EN) begin
            if (cnt_10 == 7'b1001000) begin // Gray code for 9
                cnt_10 <= 7'b0000000;
                phase_align_1 <= 1'b1;
            end else begin
                cnt_10 <= {cnt_10[5:0], ~cnt_10[6]}; // Gray code increment
                phase_align_1 <= 1'b0;
            end
        end
    end
    
    // Synchronize 1MHz with input clock domain
    reg [1:0] sync_1;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            sync_1 <= 2'b00;
        end else begin
            sync_1 <= {sync_1[0], phase_align_1};
        end
    end
    
    assign CLK_1 = sync_1[1];

endmodule