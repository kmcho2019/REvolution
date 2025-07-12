module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    // Transition detection logic
    wire [31:0] transition = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev_in <= in;
            captured <= captured | transition;  // Set and hold any detected transitions
        end
    end

    assign out = captured;

endmodule