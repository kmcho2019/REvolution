module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Two-stage delay registers for each bit
    reg [7:0] delay1;
    reg [7:0] delay2;
    
    // Intermediate edge detection signals
    wire [7:0] edge_short;  // Immediate edge (1-cycle)
    wire [7:0] edge_long;   // Delayed edge (2-cycle)
    
    assign edge_short = in ^ delay1;
    assign edge_long = delay1 ^ delay2;
    
    always @(posedge clk) begin
        // Update delay registers
        delay2 <= delay1;
        delay1 <= in;
        
        // Combine edge detection from different time windows
        anyedge <= edge_short | edge_long;
    end

endmodule