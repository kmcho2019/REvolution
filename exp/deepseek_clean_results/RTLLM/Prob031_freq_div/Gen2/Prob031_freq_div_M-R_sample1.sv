module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division ratios
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter for 10MHz clock (divide by 10)
    reg [3:0] cnt_10;  // Increased to 4 bits for better readability
    
    // Counter for 1MHz clock (divide by 100)
    reg [6:0] cnt_100; // Increased to 7 bits for better readability

    // 50MHz clock generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz clock generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= DIV_10/2 - 1; // Down counter initialization
        end else begin
            if (cnt_10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= DIV_10/2 - 1;
            end else begin
                cnt_10 <= cnt_10 - 1;
            end
        end
    end

    // 1MHz clock generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= DIV_1/2 - 1; // Down counter initialization
        end else begin
            if (cnt_100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= DIV_1/2 - 1;
            end else begin
                cnt_100 <= cnt_100 - 1;
            end
        end
    end

endmodule