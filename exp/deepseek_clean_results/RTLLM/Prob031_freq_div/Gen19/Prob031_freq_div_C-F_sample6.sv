module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // CLK_50 generation (divide by 2) - direct toggle
    reg clk50_reg;
    assign CLK_50 = clk50_reg;

    // CLK_10 generation (divide by 10)
    reg [2:0] cnt10;  // counts 4 down to 0 (5 cycles)

    // CLK_1 generation (divide by 100)
    reg [5:0] cnt100; // counts 49 down to 0 (50 cycles)

    // CLK_50 logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk50_reg <= 1'b0;
        end else begin
            clk50_reg <= ~clk50_reg;
        end
    end

    // CLK_10 logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt10 <= 3'd4;
        end else begin
            if (cnt10 == 0) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 3'd4;
            end else begin
                cnt10 <= cnt10 - 1'b1;
            end
        end
    end

    // CLK_1 logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt100 <= 6'd49;
        end else begin
            if (cnt100 == 0) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= 6'd49;
            end else begin
                cnt100 <= cnt100 - 1'b1;
            end
        end
    end

endmodule