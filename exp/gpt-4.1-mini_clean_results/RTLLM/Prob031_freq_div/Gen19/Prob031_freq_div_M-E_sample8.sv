module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for toggle intervals in CLK_in cycles
    localparam TOGGLE_50  = 1;   // Toggle every 1 cycle for 50MHz (100MHz/2)
    localparam TOGGLE_10  = 5;   // Toggle every 5 cycles for 10MHz (100MHz/10)
    localparam TOGGLE_1   = 50;  // Toggle every 50 cycles for 1MHz (100MHz/100)

    // The maximum count is the LCM of all toggle intervals - here 50 cycles
    localparam COUNTER_MAX = TOGGLE_1; 

    reg [5:0] counter; // Enough bits to count to 50

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 6'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter, wrap at COUNTER_MAX-1
            if (counter == COUNTER_MAX - 1)
                counter <= 6'd0;
            else
                counter <= counter + 1'b1;

            // Toggle CLK_50 every TOGGLE_50 cycles (every cycle)
            // Since TOGGLE_50 = 1, toggle at every counter value (every clock)
            if (counter % TOGGLE_50 == TOGGLE_50 - 1)
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every TOGGLE_10 cycles (every 5 cycles)
            if (counter % TOGGLE_10 == TOGGLE_10 - 1)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every TOGGLE_1 cycles (every 50 cycles)
            if (counter == TOGGLE_1 - 1)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule