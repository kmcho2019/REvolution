module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Calculate counter widths
    localparam CNT_WIDTH = $clog2(DIV_1);
    
    // Shared counter for CLK_10 and CLK_1
    reg [CNT_WIDTH-1:0] shared_cnt;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Shared counter and CLK_10 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            shared_cnt <= 0;
            CLK_10 <= 1'b0;
        end else begin
            // Increment shared counter
            if (shared_cnt == DIV_1-1) begin
                shared_cnt <= 0;
            end else begin
                shared_cnt <= shared_cnt + 1'b1;
            end
            
            // Toggle CLK_10 at count (DIV_10/2)-1
            if (shared_cnt == (DIV_10/2)-1) begin
                CLK_10 <= ~CLK_10;
            end
        end
    end

    // CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else begin
            // Toggle CLK_1 at count (DIV_1/2)-1
            if (shared_cnt == (DIV_1/2)-1) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule