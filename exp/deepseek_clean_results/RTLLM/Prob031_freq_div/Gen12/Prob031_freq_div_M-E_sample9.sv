module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Unified counter (0-99)
    reg [6:0] main_counter;

    // Counter increment logic
    always @(posedge CLK_in) begin
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

    // CLK_50 generation (toggle every 1 count = 100MHz/2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (toggle every 10 counts = 100MHz/10)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (main_counter % 10 == 0) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (toggle every 100 counts = 100MHz/100)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (main_counter == 7'd0) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule