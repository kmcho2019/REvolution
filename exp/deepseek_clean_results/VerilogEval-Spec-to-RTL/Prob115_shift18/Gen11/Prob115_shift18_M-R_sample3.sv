module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift direction selection
wire do_left_shift = ~amount[1];
wire do_right_shift = amount[1];

// Left shift variants
wire [63:0] left_shift_result = 
    amount[0] ? {q[55:0], 8'b0} :  // left by 8
               {q[62:0], 1'b0};    // left by 1

// Right shift variants (arithmetic)
wire [63:0] right_shift_result = 
    amount[0] ? {{8{q[63]}}, q[63:8]} :  // right by 8 with sign extension
                {q[63], q[63:1]};        // right by 1 with sign extension

// Direction selection
wire [63:0] shifted_value = 
    do_left_shift ? left_shift_result :
                    right_shift_result;

// Operation selection (load has priority over shift)
wire [63:0] next_q = 
    load ? data :
    ena ? shifted_value :
    q;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule