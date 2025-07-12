module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Parallel computation of all possible next states
wire [99:0] next_left = {q[98:0], q[99]};    // Left rotation
wire [99:0] next_right = {q[0], q[99:1]};    // Right rotation
wire [99:0] next_hold = q;                   // No rotation
wire [99:0] next_load = data;                // Load operation

// Combined next state selection
reg [1:0] ctrl_sel;
always @(*) begin
    casex ({load, ena})
        3'b1_xx: ctrl_sel = 2'b11;      // Load has highest priority
        3'b0_01: ctrl_sel = 2'b01;      // Right rotate
        3'b0_10: ctrl_sel = 2'b10;      // Left rotate
        default: ctrl_sel = 2'b00;       // Hold (ena=00 or 11)
    endcase
end

// Final next state selection
wire [99:0] next_q;
assign next_q = (ctrl_sel == 2'b00) ? next_hold :
                (ctrl_sel == 2'b01) ? next_right :
                (ctrl_sel == 2'b10) ? next_left :
                next_load;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule