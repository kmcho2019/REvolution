module TopModule (
    input           clk,
    input           load,
    input           ena,
    input      [1:0] amount,
    input     [63:0] data,
    output reg [63:0] q
);

    wire direction = amount[1];  // 0 = left shift, 1 = arithmetic right shift
    wire shift8    = amount[0];  // 0 = shift by 1, 1 = shift by 8

    wire [63:0] shifted_left_1  = q << 1;
    wire [63:0] shifted_left_8  = q << 8;
    wire [63:0] shifted_right_1 = q >>> 1;   // arithmetic right shift with sign extension
    wire [63:0] shifted_right_8 = q >>> 8;

    wire [63:0] shifted =
        (direction == 1'b0) ? // Left shift
            (shift8 ? shifted_left_8 : shifted_left_1)
        :                    // Arithmetic right shift
            (shift8 ? shifted_right_8 : shifted_right_1);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule