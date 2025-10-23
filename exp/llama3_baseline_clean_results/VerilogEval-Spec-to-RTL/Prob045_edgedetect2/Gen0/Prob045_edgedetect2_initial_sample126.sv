module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous input value
reg [7:0] anyedge_reg;  // Register for output

always @ (posedge clk) begin
    // Store the current input value for next cycle's comparison
    prev_in <= in;
    
    // For each bit, check if there's a difference between current and previous input
    for (int i = 0; i < 8; i++) begin
        if (in[i] !== prev_in[i]) begin
            // If different, set the corresponding output bit high
            anyedge_reg[i] <= 1'b1;
        end else begin
            // If no edge, keep the output bit low
            anyedge_reg[i] <= 1'b0;
        end
    end
end

assign anyedge = anyedge_reg;

endmodule