module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Store current input for next cycle
            prev_in <= in;
            
            // Detect falling edges and set corresponding capture bits
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule