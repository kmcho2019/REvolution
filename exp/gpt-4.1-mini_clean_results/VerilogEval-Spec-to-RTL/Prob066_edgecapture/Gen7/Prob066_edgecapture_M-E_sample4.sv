module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] sampled;     // Holds previous cycle's input
    reg [31:0] captured;    // Captured falling edge bits latched until reset

    wire [31:0] falling_edge;

    // Detect falling edges: previous sampled=1, current in=0
    assign falling_edge = sampled & ~in;

    always @(posedge clk) begin
        if (reset) begin
            sampled  <= 32'b0;
            captured <= 32'b0;
            out      <= 32'b0;
        end else begin
            captured <= captured | falling_edge; // latch falling edges
            sampled  <= in;                      // sample current input for next cycle
            out      <= captured;
        end
    end

endmodule