module TopModule(
    input clk,  
    input d,    
    output reg q 
);

// Internal signals for phase-shifted clocks
reg clk_180;

// Clock phase-shifter (180-degree phase shift)
always @(posedge clk or negedge clk) begin
    clk_180 <= ~clk;
end

// Single flip-flop with phase-shifted clock selection
reg flip_flop_q1, flip_flop_q2;
always @(posedge clk) begin
    flip_flop_q1 <= d;
end
always @(posedge clk_180) begin
    flip_flop_q2 <= d;
end

// Output selection based on original clock phase
assign q = (clk == 1'b1)? flip_flop_q1 : flip_flop_q2;

endmodule