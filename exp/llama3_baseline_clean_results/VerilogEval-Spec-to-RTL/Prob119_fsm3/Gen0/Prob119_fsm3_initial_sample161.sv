`timescale 1ns/1ps

module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// Define the current state
reg [1:0] curr_state;
reg [1:0] next_state;

// Define the output
reg out_reg;

// Combinational logic to determine the next state
always @(*) begin
    case (curr_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// Combinational logic to determine the output
always @(*) begin
    case (curr_state)
        A: out_reg = 1'b0;
        B: out_reg = 1'b0;
        C: out_reg = 1'b0;
        D: out_reg = 1'b1;
        default: out_reg = 1'b0;
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        curr_state <= A;
    end else begin
        curr_state <= next_state;
    end
end

// Output the out signal
assign out = out_reg;

endmodule