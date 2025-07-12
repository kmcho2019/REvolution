module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input clear,
    input load,
    input dir,  // 0 for right shift (count up), 1 for left shift (count down)
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] Q
);

wire [WIDTH-1:0] next_state;

// Next state logic
assign next_state = load ? data_in : 
                   dir ? {Q[WIDTH-2:0], ~Q[WIDTH-1]} :  // Left shift for count down
                   {~Q[0], Q[WIDTH-1:1]};             // Right shift for count up

// Dual-edge triggered flip-flop
always @(posedge clk or negedge clk) begin
    if (clear) begin
        Q <= {WIDTH{1'b0}};
    end else begin
        Q <= next_state;
    end
end

endmodule