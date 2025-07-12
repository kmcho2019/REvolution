module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Shared counter (7 bits needed for DIV_1/2 = 50 counts)
    reg [6:0] counter;
    wire [6:0] counter_gray;
    
    // Gray code conversion
    assign counter_gray = counter ^ (counter >> 1);
    
    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (counter[0]) begin  // Toggle every other cycle
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (counter == (DIV_10/2)-1) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (divide by 100) using Gray code
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (counter_gray == ((DIV_1/2)-1) ^ (((DIV_1/2)-1) >> 1)) begin
            CLK_1 <= ~CLK_1;
        end
    end

    // Shared counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'b0;
        end else begin
            if (counter == DIV_1-1) begin
                counter <= 7'b0;
            end else begin
                counter <= counter + 7'b1;
            end
        end
    end

endmodule