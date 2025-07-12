module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

reg [31:0] upper;
reg [31:0] lower;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        upper <= 32'b0;
        lower <= 32'b0;
        Q <= 64'b0;
    end else begin
        // Determine new MSB bit based on current LSB of entire 64-bit value
        // Q = {upper, lower}, so Q[0] = lower[0]
        wire new_msb = ~lower[0];
        
        // Shift lower and upper registers right by 1 bit, 
        // lower receives upper's LSB as its MSB,
        // upper receives new_msb as its MSB.
        lower <= {upper[0], lower[31:1]};
        upper <= {new_msb, upper[31:1]};
        
        // Update Q by concatenation
        Q <= {upper, lower};
    end
end

endmodule