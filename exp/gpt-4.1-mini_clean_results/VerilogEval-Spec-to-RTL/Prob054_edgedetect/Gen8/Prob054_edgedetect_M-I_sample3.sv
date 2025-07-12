module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire any_rising_edge;

    // Detect if any bit rises from 0 to 1
    assign any_rising_edge = |((~prev_in) & in);

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
        // Update prev_in only if any bit has a rising edge to reduce toggling
        if (any_rising_edge)
            prev_in <= in;
    end

endmodule