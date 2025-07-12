module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;   // Previous input value
    reg [31:0] sticky;    // Sticky output register

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            sticky <= 32'b0;
        end else begin
            in_prev <= in;  // Store current input for next cycle
            sticky <= sticky | (in_prev & ~in);  // Set sticky bits on falling edges
        end
    end

    assign out = sticky;

endmodule