module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;      // Previous cycle's input
    reg [31:0] captured;     // Sticky capture register
    
    // Combinational falling edge detection
    wire [31:0] falling_edge = prev_in & ~in;
    
    // Output assignment
    assign out = captured;

    // Previous input register
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end
        else begin
            prev_in <= in;
        end
    end

    // Capture register (sticky until reset)
    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end
        else begin
            captured <= captured | falling_edge;
        end
    end

endmodule