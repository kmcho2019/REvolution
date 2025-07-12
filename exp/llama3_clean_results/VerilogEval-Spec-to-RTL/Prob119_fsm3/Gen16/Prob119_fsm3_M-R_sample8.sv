module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using binary encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Combinational logic for next state using assign
wire [1:0] next_state;
assign next_state = (state == A && in)? B :
                   (state == A &&!in)? A :
                   (state == B && in)? B :
                   (state == B &&!in)? C :
                   (state == C && in)? D :
                   (state == C &&!in)? A :
                   (state == D && in)? B :
                   (state == D &&!in)? C : A;

// Combinational logic for output using assign
assign out = (state == D)? 1 : 0;

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule