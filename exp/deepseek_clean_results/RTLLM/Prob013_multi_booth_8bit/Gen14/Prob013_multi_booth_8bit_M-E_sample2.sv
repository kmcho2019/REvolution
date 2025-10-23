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
    reg [8:0] multiplier;  // Extra bit for Booth encoding
    reg [4:0] counter;
    reg [15:0] accum;
    reg [15:0] pp [0:3];   // Partial products
    
    // Booth encoding wires
    wire [1:0] booth_code;
    wire [15:0] pp_selected;
    
    // Generate all possible partial products in parallel
    always @(*) begin
        pp[0] = 16'b0;                          // 0*A
        pp[1] = {{8{a[7]}}, a};                 // +1*A
        pp[2] = {{7{a[7]}}, a, 1'b0};           // +2*A
        pp[3] = ~({{7{a[7]}}, a, 1'b0}) + 1'b1; // -2*A
    end
    
    // Booth encoding logic
    assign booth_code = multiplier[1:0];
    
    // Partial product selection mux
    assign pp_selected = (booth_code == 2'b00 || booth_code == 2'b11) ? pp[0] :
                        (booth_code == 2'b01) ? pp[1] :
                        (booth_code == 2'b10) ? pp[3] : pp[2];
    
    // Main state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // Initialize with extra 0 for Booth
            accum <= 16'b0;
            counter <= 5'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (counter < 8) begin
                // Accumulate partial product with proper shifting
                accum <= accum + (pp_selected << (counter * 2));
                
                // Shift multiplier right by 2 for next Booth encoding
                multiplier <= multiplier >> 2;
                
                counter <= counter + 1;
            end else begin
                // Final result available
                p <= accum;
                rdy <= 1'b1;
            end
        end
    end

endmodule