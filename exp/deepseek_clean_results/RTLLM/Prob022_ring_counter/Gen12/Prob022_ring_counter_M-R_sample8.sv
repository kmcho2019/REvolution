module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;
wire [7:0] next_state;

// Next state logic (rotate left with wrap-around)
assign next_state = reset ? 8'b00000001 : 
                   {state[6:0], state[7]};

// Output assignment
assign out = state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b00000001;
    end
    else begin
        state <= next_state;
    end
end

endmodule