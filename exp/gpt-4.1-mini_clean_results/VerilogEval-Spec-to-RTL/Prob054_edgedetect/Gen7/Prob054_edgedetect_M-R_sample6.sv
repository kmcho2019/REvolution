module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    // Sequential logic to store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational logic to detect rising edge bitwise
    assign pedge = (~prev_in) & in;

endmodule