module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Determine rotation amount based on direction
wire rotate_left = (ena == 2'b10);
wire rotate_right = (ena == 2'b01);
wire [6:0] rotate_amount = rotate_left ? 7'd1 : 
                          rotate_right ? 7'd99 : 
                          7'd0;

// Barrel shifter implementation
wire [99:0] rotated_value;
assign rotated_value = (q << rotate_amount) | (q >> (100-rotate_amount));

// Next state logic
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_left || rotate_right) begin
        q <= rotated_value;
    end
    // else hold value (implicit)
end

endmodule