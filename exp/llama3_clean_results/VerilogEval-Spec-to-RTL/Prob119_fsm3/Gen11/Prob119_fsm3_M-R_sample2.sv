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

// Define the state register
reg [1:0] state;

// Combinational logic for next state
wire [1:0] next_state_A = in ? B : A;
wire [1:0] next_state_B = in ? B : C;
wire [1:0] next_state_C = in ? D : A;
wire [1:0] next_state_D = in ? B : C;

// Use a simple multiplexing to select the next state based on the current state
wire [1:0] next_state;
assign next_state = (state == A) ? next_state_A :
                    (state == B) ? next_state_B :
                    (state == C) ? next_state_C :
                    (state == D) ? next_state_D :
                    A; // Default state

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = (state == D);

endmodule