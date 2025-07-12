module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // 32-bit register to store previous input values
    reg [31:0] prev_in;
    
    // 32-bit register for output memory
    reg [31:0] out_reg;
    
    // Falling edge detection wires
    wire [31:0] falling_edge;
    
    assign falling_edge = prev_in & ~in;
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            prev_in <= in;
            // Set output bits when falling edge detected, maintain until reset
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule