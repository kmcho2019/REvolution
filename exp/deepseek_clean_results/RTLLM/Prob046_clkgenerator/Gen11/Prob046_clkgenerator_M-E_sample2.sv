module clkgenerator #(
    parameter PERIOD = 10,      // Clock period in base clock cycles
    parameter ACC_WIDTH = 16    // Phase accumulator width
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    output reg clk             // Generated clock output
);

    // Calculate phase increment (fixed-point arithmetic)
    localparam PHASE_INC = (2**ACC_WIDTH) / PERIOD;
    
    // Phase accumulator
    reg [ACC_WIDTH-1:0] phase_acc;
    wire phase_overflow;
    
    // Overflow occurs when addition crosses accumulator width
    assign phase_overflow = (phase_acc + PHASE_INC) < phase_acc;
    
    // Sequential logic
    always @(posedge clk_base) begin
        if (!reset_n) begin
            phase_acc <= 0;
            clk <= 1'b0;
        end
        else begin
            phase_acc <= phase_acc + PHASE_INC;
            
            if (phase_overflow) begin
                clk <= ~clk;
            end
        end
    end

endmodule