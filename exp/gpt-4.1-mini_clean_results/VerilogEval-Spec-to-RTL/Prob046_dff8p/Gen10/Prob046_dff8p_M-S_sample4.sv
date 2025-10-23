module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    // Reset value 0x34 = 8'b00110100
    localparam [7:0] RESET_VAL = 8'h34;

    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule