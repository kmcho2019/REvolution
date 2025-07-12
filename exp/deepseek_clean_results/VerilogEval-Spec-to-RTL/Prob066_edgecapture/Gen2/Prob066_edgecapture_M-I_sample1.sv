module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    // Register previous input value
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Detect falling edges and maintain captured state
    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end else begin
            captured <= (prev_in & ~in) | captured;
        end
    end

    assign out = captured;

endmodule