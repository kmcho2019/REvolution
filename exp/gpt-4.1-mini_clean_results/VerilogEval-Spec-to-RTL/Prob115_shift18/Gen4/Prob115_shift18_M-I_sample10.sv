module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode control signals from amount
    wire direction = amount[1];  // 0=left shift, 1=right arithmetic shift
    wire shift8    = amount[0];  // shift by 8 bits if set
    wire shift1    = ~amount[0]; // shift by 1 bit if set (for 2'b00 and 2'b10)
    
    // Combine shift amount into single value for convenience
    wire [5:0] shift_val = shift8 ? 6'd8 : 6'd1;

    // Left shift by shift_val
    wire [63:0] left_shifted = (shift_val == 6'd1) ? (q << 1) : (q << 8);

    // Arithmetic right shift by shift_val
    wire [63:0] right_shifted = (shift_val == 6'd1) ?
        { {1{q[63]}}, q[63:1] } << 0 :   // shift right by 1 with sign extension
        { {8{q[63]}}, q[63:8] } << 0;    // shift right by 8 with sign extension

    // Select shifted value based on direction
    wire [63:0] shifted = direction ? right_shifted : left_shifted;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule