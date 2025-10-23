module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    reg [1:0] counter;    // 2-bit counter for 4 cycles (3 down to 0)
    
    // On reset, start counting down from 3 (4 cycles)
    // After counter reaches 0, shift_ena is deasserted forever until reset
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'd3; // 4 cycles: counts 3,2,1,0
        end else if (counter != 2'd0) begin
            counter <= counter - 1;
        end
    end
    
    assign shift_ena = (counter != 2'd0) || (counter == 2'd0 && reset);

endmodule