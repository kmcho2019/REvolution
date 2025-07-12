module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;   // input from previous cycle
    reg [31:0] captured;  // sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            captured <= captured | (prev_in & ~in);  // Capture all falling edges
            prev_in <= in;
        end
    end

    assign out = captured;

endmodule