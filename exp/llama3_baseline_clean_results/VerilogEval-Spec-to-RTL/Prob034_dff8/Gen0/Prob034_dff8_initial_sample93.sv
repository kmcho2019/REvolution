module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] q; // Declare q as a reg type to be used within always block

    always @(posedge clk) begin
        q <= d; // Assign input d to output q at positive edge of clock
    end

endmodule