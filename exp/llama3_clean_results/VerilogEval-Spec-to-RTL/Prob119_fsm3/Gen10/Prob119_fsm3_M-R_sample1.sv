module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states with minimal encoding (2 bits)
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Current state variable
reg [1:0] current_state;

// Next state logic
wire [1:0] next_state;

assign next_state = 
    (current_state == A) ? (in ? B : A) :
    (current_state == B) ? (in ? B : C) :
    (current_state == C) ? (in ? D : A) :
    (current_state == D) ? (in ? B : C) : 2'd0;

// Synchronous reset and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for output, simplified to directly check for state D
assign out = (current_state == D) ? 1'd1 : 1'd0;

endmodule