module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 3-stage shift register for each bit
    reg [7:0] in_history [0:2];
    
    always @(posedge clk) begin
        // Shift new values into history
        in_history[2] <= in_history[1];
        in_history[1] <= in_history[0];
        in_history[0] <= in;
        
        // Edge detected if middle sample differs from either neighbor
        anyedge <= (in_history[1] ^ in_history[0]) |  // Current vs previous
                   (in_history[1] ^ in_history[2]);   // Current vs next
    end

endmodule