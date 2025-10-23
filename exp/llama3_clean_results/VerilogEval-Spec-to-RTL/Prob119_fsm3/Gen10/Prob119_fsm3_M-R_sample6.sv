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
reg [1:0] next_state;

// Initialize current state with parameter A
initial current_state = A;

// Combinational logic for next state
always @(*) begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

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