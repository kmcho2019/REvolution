module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
wire do_shift = ena & ~load;
wire [5:0] shift_amount = amount[0] ? 3'd8 : 3'd1;
wire shift_right = amount[1];

// Optimized single always block implementation
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        if (shift_right) begin
            // Arithmetic right shift using Verilog operator
            q <= $signed(q) >>> shift_amount;
        end
        else begin
            // Left shift
            q <= q << shift_amount;
        end
    end
    // Implicit else retains value (no clock gating shown in RTL)
end

endmodule