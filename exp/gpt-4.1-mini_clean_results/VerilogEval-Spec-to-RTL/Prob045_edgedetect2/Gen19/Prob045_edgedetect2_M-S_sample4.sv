module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= prev_in ^ in;  // edge detected last cycle
        prev_in <= in;            // update previous input
    end

endmodule