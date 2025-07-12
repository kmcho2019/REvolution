module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational detection of falling edges
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: clear output and initialize prev_in to current input
            out <= 32'b0;
            prev_in <= in;
        end else begin
            // Update sticky output with falling edges and update prev_in
            out <= out | falling_edge;
            prev_in <= in;
        end
    end

endmodule