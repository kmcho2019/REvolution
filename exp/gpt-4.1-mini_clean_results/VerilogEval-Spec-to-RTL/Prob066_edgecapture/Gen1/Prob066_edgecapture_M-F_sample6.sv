module TopModule (
    input        clk,
    input        reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] transition;

    // Detect bits that transitioned from 1 to 0
    assign transition = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'hFFFFFFFF; // Initialize to all ones to detect initial 1->0 transitions
        end else begin
            out <= out | transition; // latch transition bits
            prev_in <= in;
        end
    end

endmodule