module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// State register
reg [1:0] state;

// Next state logic
wire [1:0] next_state;
assign next_state = (state == A) ? (in ? B : A) :
                     (state == B) ? (in ? B : C) :
                     (state == C) ? (in ? D : A) :
                     (state == D) ? (in ? B : C) : A;

// Output logic
assign out = (state == D) ? 1 : 0;

// Clock gating
reg clk_gated;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        clk_gated <= 1'b0;
    end else begin
        clk_gated <= 1'b1;
    end
end

// Sequential logic for state transition
always @(posedge clk_gated or posedge areset) begin
    if (areset) begin
        state <= A;
    end else if (clk_gated) begin
        state <= next_state;
    end
end

endmodule