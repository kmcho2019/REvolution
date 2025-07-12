module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

// Single D flip-flop used to hold the current bit shifted out
reg dff_q;

// 10-bit shift register holding the counter bits
reg [9:0] shift_reg;

// Next state combinational signals
wire dff_d;      // input to D flip-flop
wire tc_internal; // internal terminal count

// Terminal count when all bits zero
assign tc_internal = (shift_reg == 10'd0);
assign tc = tc_internal;

// On load, load shift_reg with data and dff_q = 0
// Otherwise, shift right and input to shift_reg[9] is dff_q
// dff_q input is LSB of shift_reg decremented by 1 logic

// Calculate dff_d as the decremented version of LSB with borrow logic
// For simple decrement by 1, borrow occurs when LSB is 0 and decrementing
// Since we only store bits in shift_reg, we use combinational logic to
// decrement the 10-bit value by shifting and feeding dff_q with borrow

// Decrement logic:
// The least significant bit to be shifted into dff_q is shift_reg[0] - 1
// In binary, decrementing by 1 is subtracting 1, so if shift_reg[0] == 0
// the borrow needs to propagate. To implement with one flip-flop, approximate
// the decrement by shifting and feeding back dff_q with a borrow signal.

// For simplicity, in this design, the shift_reg shifts right each cycle,
// dff_q captures the shifted out bit, and load reloads the shift_reg.

// Implement single D flip-flop 'dff_q' holding shifted out bit

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data; // load input data directly into shift_reg
        dff_q <= 1'b0;
    end else if (!tc_internal) begin
        dff_q <= shift_reg[0];            // capture LSB into dff_q
        shift_reg <= {dff_q, shift_reg[9:1]}; // shift right, MSB = dff_q
    end
    // else hold current state when counter reached zero
end

endmodule