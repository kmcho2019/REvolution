module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Single counter that counts continuously
    reg [6:0] main_counter;  // Needs to count up to 99 (for 1MHz)

    // Counter control
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_counter <= 7'd0;
        end else begin
            if (main_counter == 7'd99) begin
                main_counter <= 7'd0;
            end else begin
                main_counter <= main_counter + 1'b1;
            end
        end
    end

    // CLK_50 generation - toggle every 1 count (100MHz/2 = 50MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation - toggle every 5 counts (100MHz/10 = 10MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else begin
            if (main_counter[2:0] == 3'b100) begin  // Every 5 counts
                CLK_10 <= ~CLK_10;
            end
        end
    end

    // CLK_1 generation - toggle every 50 counts (100MHz/100 = 1MHz)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else begin
            if (main_counter == 7'd49) begin  // At count 49 (next will be 50)
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule