module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] detected;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational detection of 0->1 transitions
    assign detected = (~prev_in) & in;

    // Register detected transitions to delay output by one cycle
    always @(posedge clk) begin
        pedge <= detected;
    end

endmodule