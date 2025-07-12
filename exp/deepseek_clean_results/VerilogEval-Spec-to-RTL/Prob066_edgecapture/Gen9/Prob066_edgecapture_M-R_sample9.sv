module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] prev_prev_in;
    reg [31:0] captured;

    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            prev_prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Shift input history
            prev_prev_in <= prev_in;
            prev_in <= in;

            // Update captured bits when falling edge detected
            captured <= captured | (prev_prev_in & ~prev_in);
        end
    end

endmodule