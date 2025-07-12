module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Determine shift direction and amount
wire shift_left, shift_right, shift_by_8;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);
assign shift_by_8 = (amount == 2'b01 || amount == 2'b11);

// Calculate next state based on shift operation
wire [63:0] next_state;
assign next_state = (shift_left && !shift_by_8) ? (q_reg << 1) :
                    (shift_left && shift_by_8) ? (q_reg << 8) :
                    (shift_right && !shift_by_8) ? (q_reg >>> 1) :
                    (shift_right && shift_by_8) ? (q_reg >>> 8) :
                    q_reg;

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= next_state;
    end
end

// Output assignment
assign q = q_reg;

endmodule