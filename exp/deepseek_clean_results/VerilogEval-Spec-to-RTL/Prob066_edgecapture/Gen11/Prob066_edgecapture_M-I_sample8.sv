module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] captured; // Serves dual purpose: sticky bits and previous input
    
    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end
        else begin
            // Detect falling edges and update sticky bits
            captured <= captured | (captured & ~in);
            // Store current input for next cycle comparison
            captured <= captured | in;
        end
    end

endmodule