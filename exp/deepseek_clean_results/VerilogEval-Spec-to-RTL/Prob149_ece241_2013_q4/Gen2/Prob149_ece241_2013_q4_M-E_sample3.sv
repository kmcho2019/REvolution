module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;
    wire rising_edge;
    wire [1:0] water_level;
    
    // Synchronous sensor history and edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end
    
    // Detect if water level is rising (any new sensor activated)
    assign rising_edge = (s[0] & ~prev_s[0]) | 
                        (s[1] & ~prev_s[1]) | 
                        (s[2] & ~prev_s[2]);
    
    // Priority encoder for water level (highest active sensor)
    assign water_level = s[2] ? 2'b11 :
                         s[1] ? 2'b10 :
                         s[0] ? 2'b01 : 2'b00;
    
    // Flow rate outputs
    assign fr0 = reset ? 1'b1 : (water_level < 2'b11);  // On unless above s[2]
    assign fr1 = reset ? 1'b1 : (water_level < 2'b10);  // On unless at/above s[1]
    assign fr2 = reset ? 1'b1 : (water_level == 2'b00); // On only when below s[0]
    assign dfr = reset ? 1'b1 : rising_edge;           // Supplemental flow when rising
    
endmodule