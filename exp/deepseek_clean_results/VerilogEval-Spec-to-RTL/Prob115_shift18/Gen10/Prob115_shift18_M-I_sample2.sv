module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Gated shift computation
wire [63:0] shift_result;
wire do_shift = ena & ~load;

// Shared sign extension for right shifts
wire sign_bit = q[63];
wire [7:0] sign_byte = {8{sign_bit}};

always @(*) begin
    if (load) begin
        shift_result = data;
    end
    else if (do_shift) begin
        case (amount)
            2'b00: shift_result = {q[62:0], 1'b0};          // Left 1
            2'b01: shift_result = {q[55:0], 8'b0};          // Left 8
            2'b10: shift_result = {sign_bit, q[63:1]};      // Right 1
            2'b11: shift_result = {sign_byte, q[63:8]};     // Right 8
            default: shift_result = q;
        endcase
    end
    else begin
        shift_result = q;
    end
end

// Clock-gated register update
always @(posedge clk) begin
    q <= shift_result;
end

endmodule