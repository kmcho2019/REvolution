module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8-bit + 1 guard bit
    reg [2:0] counter;      // Only need 3 bits (0-4)
    reg [15:0] accum;
    
    // Booth encoding wires
    wire [1:0] booth_code;
    wire [15:0] pp;
    wire [15:0] shifted_pp;
    
    // Sign-extended multiplicand
    wire [15:0] a_ext = {{8{a[7]}}, a};
    
    // Booth encoding (current 2 bits + previous bit)
    assign booth_code = multiplier[1:0];
    
    // Partial product generation
    assign pp = (booth_code == 2'b01) ? a_ext :
                (booth_code == 2'b10) ? (~a_ext + 1'b1) : 16'b0;
    
    // Properly shifted partial product
    assign shifted_pp = pp << (counter * 2);
    
    // Main state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= a_ext;
            multiplier <= {b, 1'b0};  // Initialize with guard bit
            accum <= 16'b0;
            counter <= 3'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (counter < 4) begin
                // Accumulate shifted partial product
                accum <= accum + shifted_pp;
                
                // Arithmetic right shift by 2 for next Booth encoding
                multiplier <= {multiplier[8], multiplier[8:2]};
                
                counter <= counter + 1;
            end else begin
                // Final result available after 4 cycles
                p <= accum;
                rdy <= 1'b1;
            end
        end
    end

endmodule