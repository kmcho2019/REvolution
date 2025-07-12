module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared counter parameters
    parameter COUNTER_WIDTH = 7; // Enough for 100 divisions (2^7=128)
    reg [COUNTER_WIDTH-1:0] counter;
    wire [COUNTER_WIDTH-1:0] counter_gray;
    
    // Convert binary counter to Gray code
    assign counter_gray = counter ^ (counter >> 1);

    // Clock generation logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 0;
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Increment shared counter
            counter <= counter + 1;
            
            // Generate CLK_50 (toggle every 1 count)
            if (counter[0] == 1'b0) CLK_50 <= ~CLK_50;
            
            // Generate CLK_10 (toggle every 5 counts)
            if (counter_gray == 5) CLK_10 <= ~CLK_10;
            
            // Generate CLK_1 (toggle every 50 counts)
            if (counter_gray == 50) CLK_1 <= ~CLK_1;
        end
    end

    // Synchronize all clocks to rise together
    always @(negedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Hold values during negative phase
            CLK_50 <= CLK_50;
            CLK_10 <= CLK_10;
            CLK_1 <= CLK_1;
        end
    end

endmodule