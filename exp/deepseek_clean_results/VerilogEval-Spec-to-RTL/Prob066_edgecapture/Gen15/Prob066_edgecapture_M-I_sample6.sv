module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;   // Input from previous cycle
    reg [31:0] current_in; // Input from current cycle (registered)
    reg [31:0] captured;  // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            current_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev_in <= current_in;
            current_in <= in;
            captured <= captured | (prev_in & ~current_in);
        end
    end

    assign out = captured;

endmodule