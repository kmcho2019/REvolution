module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [63:0] shift_left_1;
reg [63:0] shift_left_8;
reg [63:0] shift_right_1;
reg [63:0] shift_right_8;

always @(posedge clk) begin
    if (load) begin
        q <= data;
        shift_left_1 <= data;
        shift_left_8 <= data;
        shift_right_1 <= data;
        shift_right_8 <= data;
    end else if (ena) begin
        shift_left_1 <= {shift_left_1[62:0], 1'b0};
        shift_left_8 <= {shift_left_8[55:0], 8'b0};
        shift_right_1 <= {shift_right_1[63], shift_right_1[63:1]};
        shift_right_8 <= {8{shift_right_8[63]}, shift_right_8[63:8]};
        
        case (amount)
            2'b00: q <= shift_left_1;
            2'b01: q <= shift_left_8;
            2'b10: q <= shift_right_1;
            2'b11: q <= shift_right_8;
            default: q <= q;
        endcase
    end else begin
        q <= q;
        shift_left_1 <= shift_left_1;
        shift_left_8 <= shift_left_8;
        shift_right_1 <= shift_right_1;
        shift_right_8 <= shift_right_8;
    end
end

endmodule