module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] detected;

    // Combinational detection of 0->1 per bit using stored prev_in and current in
    assign detected = (~prev_in) & in;

    // Single always block: update prev_in and pedge on posedge clk
    always @(posedge clk) begin
        prev_in <= in;     // store current input for next cycle detection
        pedge   <= detected; // output delayed positive edge detection
    end

endmodule