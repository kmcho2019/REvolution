module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shift_result;
wire shift_left;
wire [3:0] shift_amount;

// Decode shift direction and amount
assign shift_left = ~amount[1];
assign shift_amount = (amount[0]) ? 4'd8 : 4'd1;

// Shift operation
assign shift_result = shift_left ? 
                     (q << shift_amount) : 
                     ({{64{q[63]}}} >> (64 - shift_amount)) | (q >> shift_amount);

// Next state logic
wire [63:0] next_q = load ? data : (ena ? shift_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule