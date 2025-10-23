module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output wire [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;
    reg [31:0] captured;

    // Combinational detection of falling edge: previous bit was 1 and current bit is 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            // Capture any detected falling edges, hold until reset
            captured <= captured | falling_edge;
        end
    end

    assign out = captured;

endmodule