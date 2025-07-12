module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter registers
    reg [5:0] cnt_10 = 0;  // Counts 0-9 (needs 4 bits)
    reg [6:0] cnt_1 = 0;   // Counts 0-99 (needs 7 bits)
    reg toggle_50 = 0;
    
    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            toggle_50 <= 0;
        end else begin
            toggle_50 <= ~toggle_50;
        end
    end
    assign CLK_50 = toggle_50;
    
    // Counter for 10MHz clock (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_10 <= 0;
        end else if (cnt_10 == DIV_10-1) begin
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
    assign CLK_10 = (cnt_10 < DIV_10/2) ? 1'b1 : 1'b0;
    
    // Counter for 1MHz clock (divide by 100)
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_1 <= 0;
        end else if (cnt_1 == DIV_1-1) begin
            cnt_1 <= 0;
        end else begin
            cnt_1 <= cnt_1 + 1;
        end
    end
    assign CLK_1 = (cnt_1 < DIV_1/2) ? 1'b1 : 1'b0;

endmodule