module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 5;  // Half of 10 since we toggle on terminal count
    parameter DIV_1 = 50;  // Half of 100 since we toggle on terminal count
    
    // Counter widths (precisely sized)
    localparam CNT_10_WIDTH = 3;  // counts 0-4 (5 cycles)
    localparam CNT_1_WIDTH = 6;   // counts 0-49 (50 cycles)

    // Counters
    reg [CNT_10_WIDTH-1:0] cnt10;
    reg [CNT_1_WIDTH-1:0] cnt100;
    
    // Clock enables
    wire clk50_en;
    wire clk10_en;
    wire clk1_en;
    
    // Clock registers
    reg clk50_reg;
    reg clk10_reg;
    reg clk1_reg;

    // Counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt10 <= 0;
            cnt100 <= 0;
        end else begin
            // 10MHz counter (counts 0-4)
            if (cnt10 == DIV_10-1)
                cnt10 <= 0;
            else
                cnt10 <= cnt10 + 1'b1;
                
            // 1MHz counter (counts 0-49)
            if (cnt100 == DIV_1-1)
                cnt100 <= 0;
            else
                cnt100 <= cnt100 + 1'b1;
        end
    end

    // Clock enable generation
    assign clk50_en = 1'b1;  // Always enabled (toggles every cycle)
    assign clk10_en = (cnt10 == DIV_10-1);
    assign clk1_en = (cnt100 == DIV_1-1);

    // Clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk50_reg <= 1'b0;
            clk10_reg <= 1'b0;
            clk1_reg <= 1'b0;
        end else begin
            // 50MHz clock (toggle every cycle)
            if (clk50_en)
                clk50_reg <= ~clk50_reg;
                
            // 10MHz clock (toggle every 5 cycles)
            if (clk10_en)
                clk10_reg <= ~clk10_reg;
                
            // 1MHz clock (toggle every 50 cycles)
            if (clk1_en)
                clk1_reg <= ~clk1_reg;
        end
    end

    // Output assignments
    assign CLK_50 = clk50_reg;
    assign CLK_10 = clk10_reg;
    assign CLK_1 = clk1_reg;

endmodule