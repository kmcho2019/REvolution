module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Define the lookup table for next states and outputs
reg [1:0] lut_next_state [4][2];
reg [0:0] lut_out [4][2];

// Initialize the lookup table
initial begin
    lut_next_state[A][0] = A;
    lut_next_state[A][1] = B;
    lut_out[A][0] = 1'd0;
    lut_out[A][1] = 1'd0;

    lut_next_state[B][0] = C;
    lut_next_state[B][1] = B;
    lut_out[B][0] = 1'd0;
    lut_out[B][1] = 1'd0;

    lut_next_state[C][0] = A;
    lut_next_state[C][1] = D;
    lut_out[C][0] = 1'd0;
    lut_out[C][1] = 1'd0;

    lut_next_state[D][0] = C;
    lut_next_state[D][1] = B;
    lut_out[D][0] = 1'd1;
    lut_out[D][1] = 1'd1;
end

// Current state and next state variables
reg [1:0] current_state;
reg [1:0] next_state;

// Output variable
reg out_reg;

// Synchronous reset and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine next state and output
always @(*) begin
    next_state = lut_next_state[current_state][in];
    out_reg = lut_out[current_state][in];
end

// Assign output
assign out = out_reg;

endmodule