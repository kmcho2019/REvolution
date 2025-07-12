module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_left = ~amount[1];
wire [6:0] shift_amount = (amount[0]) ? 7'd8 : 7'd1;
wire [63:0] sign_ext = {64{q[63]}}; // For arithmetic right shift

// Barrel shifter implementation
wire [63:0] shifted_value;
assign shifted_value = shift_left ? 
                      (q << shift_amount) : 
                      ((q >> shift_amount) | (sign_ext & ~({64{1'b1}} >> shift_amount)));

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_value;
    end
end

endmodule