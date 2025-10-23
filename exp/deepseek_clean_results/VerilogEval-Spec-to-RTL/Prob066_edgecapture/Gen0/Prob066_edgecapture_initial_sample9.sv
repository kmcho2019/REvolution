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
        end else begin
            prev_in <= in;
            // For each bit, set if we detect falling edge (1->0)
            // or keep previous set value
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule