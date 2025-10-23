module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] fall_edge;

    // Combinational detection of falling edges
    assign fall_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF;  // Initialize prev_in to all ones on reset
            out <= 32'b0;             // Clear sticky output on reset
        end else begin
            prev_in <= in;
            out <= out | fall_edge;   // Latch falling edges
        end
    end

endmodule