module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire [63:0] shift_left_1  = q << 1;
    wire [63:0] shift_left_8  = q << 8;
    wire [63:0] shift_right_1 = {q[63], q[63:1]};
    wire [63:0] shift_right_8 = { {8{q[63]}}, q[63:8] };

    wire [63:0] shifted = (amount == 2'b00) ? shift_left_1  :
                          (amount == 2'b01) ? shift_left_8  :
                          (amount == 2'b10) ? shift_right_1 :
                                              shift_right_8;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold q
    end

endmodule