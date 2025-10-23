module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out,
    output        ready
);

    reg [6:0] counter = 0;
    reg [99:0] shift_reg;
    reg internal_ready = 0;
    
    // Internal clock (would normally be an input in real design)
    wire clk;
    assign clk = 1'b1; // For simulation purposes
    
    always @(posedge clk) begin
        if (counter < 100) begin
            shift_reg[counter] <= sel ? b[counter] : a[counter];
            counter <= counter + 1;
            internal_ready <= (counter == 99);
        end
    end
    
    assign out = shift_reg;
    assign ready = internal_ready;

endmodule