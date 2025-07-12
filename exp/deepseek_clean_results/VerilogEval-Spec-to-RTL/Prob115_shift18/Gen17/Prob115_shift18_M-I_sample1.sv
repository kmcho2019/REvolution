module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Clock gating logic
wire clk_en = load | ena;
wire gated_clk = clk & clk_en;

// Control signals (gated with ena to reduce switching)
wire shift_left = ena ? ~amount[1] : 1'b0;
wire shift_by_8 = ena ? amount[0] : 1'b0;

// Shared shift logic
wire [63:0] shift_amount = shift_by_8 ? 8'd8 : 8'd1;
wire [63:0] shifted_value = shift_left ? 
                          (q << shift_amount) : 
                          ({{64{q[63]}}} >> (64 - shift_amount)) | (q >> shift_amount);

// Pipeline register for shift operations
reg [63:0] shifted_reg;
always @(posedge clk) begin
    shifted_reg <= shifted_value;
end

// Next state logic with pipelining
wire [63:0] next_q = load ? data : 
                    (ena ? shifted_reg : q);

// Main register with clock gating
always @(posedge gated_clk or posedge load) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_reg;
    end
end

endmodule