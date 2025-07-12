module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // Input from previous cycle
    reg [31:0] captured; // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // First store the previous input value
            prev_in <= in;
            
            // Then detect falling edges (1 in prev cycle, 0 in current cycle)
            // and combine with existing captures
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule