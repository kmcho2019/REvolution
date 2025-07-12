module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    // Register to hold previous cycle's input value
    reg [7:0] prev_in;

    // Register previous input at each clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational positive edge detection: bits that transitioned 0->1 in current cycle
    assign pedge = (~prev_in) & in;

endmodule