module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Next state logic
wire [1:0] next_state;
assign next_state = (state == A)? (in? B : A) :
                     (state == B)? (in? B : C) :
                     (state == C)? (in? D : A) :
                     (state == D)? (in? B : C) : 2'b00;

// Output logic
assign out = (state == D)? 1 : 0;

// Clock gating signal
reg clk_enable;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        clk_enable <= 1;
    end else begin
        // Clock gating logic
        clk_enable <= (state!= D) || in;
    end
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else if (clk_enable) begin
        state <= next_state;
    end
end

endmodule