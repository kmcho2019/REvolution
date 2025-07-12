module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign extension cache (only updates when MSB changes)
reg last_sign;
reg [7:0] sign_ext_cache;
always @(posedge clk) begin
    if (load) begin
        last_sign <= data[63];
        sign_ext_cache <= {8{data[63]}};
    end else if (ena && amount[1]) begin
        if (q[63] != last_sign) begin
            last_sign <= q[63];
            sign_ext_cache <= {8{q[63]}};
        end
    end
end

// Shift direction decoder
wire shift_right = amount[1];
wire shift_8 = amount[0];

// Pre-shift optimization: convert left shifts to equivalent right shifts
wire [63:0] shift_input = shift_right ? q : {q[0], q[63:1]};
wire [5:0] shift_amount = shift_8 ? (shift_right ? 6'd8 : 6'd55) : 
                          (shift_right ? 6'd1 : 6'd62);

// Dynamic shift calculation
wire [63:0] shifted_value;
assign shifted_value = shift_right ? 
    (shift_8 ? {sign_ext_cache, q[63:8]} : {q[63], q[63:1]}) :
    (shift_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0});

// Next state logic with optimized enable path
wire [63:0] next_q;
assign next_q = load ? data : (ena ? shifted_value : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule