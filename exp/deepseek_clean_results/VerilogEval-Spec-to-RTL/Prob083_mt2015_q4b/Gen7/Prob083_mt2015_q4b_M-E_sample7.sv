module TopModule (
    input x,
    input y,
    output reg z
);
    reg x_prev, y_prev;
    reg [1:0] state;
    
    // Edge detection
    wire x_rise = x & ~x_prev;
    wire y_rise = y & ~y_prev;
    
    always @(posedge x_rise or posedge y_rise) begin
        case ({x_rise, y_rise})
            2'b10: state <= 2'b01;  // Only x rose
            2'b01: state <= 2'b10;  // Only y rose
            2'b11: state <= 2'b11;  // Both rose
            default: state <= 2'b00; // No change
        endcase
    end
    
    always @* begin
        case (state)
            2'b00: z = 1;  // No recent changes
            2'b01: z = 0;  // Recent x change
            2'b10: z = 0;  // Recent y change
            2'b11: z = 1;  // Both changed
        endcase
    end
    
    always @* begin
        x_prev = x;
        y_prev = y;
    end
endmodule