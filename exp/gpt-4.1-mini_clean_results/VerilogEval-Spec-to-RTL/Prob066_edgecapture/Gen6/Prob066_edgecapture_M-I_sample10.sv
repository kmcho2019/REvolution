module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edges: previous input=1, current input=0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF; // Initialize to all ones for correct first cycle detection
            out     <= 32'b0;
        end else begin
            prev_in <= in;
            // Latch the falling edges until reset
            out <= out | falling_edge;
        end
    end

endmodule