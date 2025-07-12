module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] current_state;
reg [3:0] next_state;

// Combinational logic for next state
always @(*) begin
    if (slowena) begin
        if (current_state[3] & current_state[0])  // count == 9 (1001)
            next_state = 4'b0000;
        else
            next_state = current_state + 1'b1;
    end else begin
        next_state = current_state;  // Hold when not enabled
    end
end

// Sequential state register
always @(posedge clk) begin
    if (reset)
        current_state <= 4'b0000;
    else
        current_state <= next_state;
end

// Output assignment
assign q = current_state;

endmodule