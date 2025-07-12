module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    // Register to hold previous cycle's input value
    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect bits transitioning from 0 to 1 relative to prev_in
        pedge <= (~prev_in) & in;
        // Update prev_in with current input for next cycle comparison
        prev_in <= in;
    end

endmodule