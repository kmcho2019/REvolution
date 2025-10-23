module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Optimized control signals
wire shift_left = ~amount[1];
wire shift_by_8 = amount[0];
wire [63:0] sign_ext_1 = {1{q[63]}};
wire [63:0] sign_ext_8 = {8{q[63]}};

// Optimized barrel shifter
wire [63:0] shifted_value;
assign shifted_value = shift_left ? 
                      (shift_by_8 ? (q << 8) : (q << 1)) :
                      (shift_by_8 ? ((q >> 8) | (sign_ext_8 << 56)) : 
                                   ((q >> 1) | (sign_ext_1 << 63)));

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_value;
    end
end

endmodule