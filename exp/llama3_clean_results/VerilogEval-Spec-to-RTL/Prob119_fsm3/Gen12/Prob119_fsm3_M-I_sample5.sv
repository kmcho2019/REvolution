module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot encoded values
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State register
reg [3:0] state;

// Next state logic
wire [3:0] next_state;
assign next_state = (state == A)? (in? B : A) :
                     (state == B)? (in? B : C) :
                     (state == C)? (in? D : A) :
                     (state == D)? (in? B : C) : A;

// Output logic
assign out = (state == D)? 1 : 0;

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule