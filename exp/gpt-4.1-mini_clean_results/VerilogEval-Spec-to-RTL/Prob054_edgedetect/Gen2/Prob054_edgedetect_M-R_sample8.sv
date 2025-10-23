module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    // Register to hold previous input on every clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational logic to detect rising edges, output updated synchronously
    assign pedge = (~prev_in) & in;

endmodule