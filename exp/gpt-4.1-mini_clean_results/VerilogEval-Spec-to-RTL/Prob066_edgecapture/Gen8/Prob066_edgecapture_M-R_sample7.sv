module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output wire [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    wire [31:0] falling_edge;

    // Detect falling edges: previous input bit = 1, current input bit = 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in  <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in  <= in;
            // Latch falling edges until reset
            captured <= captured | falling_edge;
        end
    end

    // Output driven combinationally from latched captured bits
    assign out = captured;

endmodule