module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [63:0] next_q;
reg [3:0] shift_amt;
wire left_shift;
wire [63:0] shifted_val;

// Shift direction and amount decoding
always @(*) begin
    case (amount)
        2'b00: begin shift_amt = 4'd1; left_shift = 1'b1; end  // Left by 1
        2'b01: begin shift_amt = 4'd8; left_shift = 1'b1; end  // Left by 8
        2'b10: begin shift_amt = 4'd1; left_shift = 1'b0; end  // Right by 1
        2'b11: begin shift_amt = 4'd8; left_shift = 1'b0; end  // Right by 8
    endcase
end

// Shift operation
assign shifted_val = left_shift ? (q << shift_amt) : 
                    ({{64{q[63]}}} << (6'd64 - shift_amt)) | (q >> shift_amt);

// Next state logic
always @(*) begin
    if (load)
        next_q = data;
    else if (ena)
        next_q = shifted_val;
    else
        next_q = q;
end

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule