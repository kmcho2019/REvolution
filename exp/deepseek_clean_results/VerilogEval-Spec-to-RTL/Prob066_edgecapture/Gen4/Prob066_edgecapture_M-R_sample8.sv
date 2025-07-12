module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;
    wire [31:0] falling_edge;

    // Detect falling edges
    assign falling_edge = prev_in & ~in;

    // Store previous input value
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Capture and hold falling edges
    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
        end else begin
            captured <= captured | falling_edge;
        end
    end

    assign out = captured;

endmodule