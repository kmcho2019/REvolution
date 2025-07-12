module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define states
parameter A = 4'd1;
parameter B = 4'd2;
parameter C = 4'd4;
parameter D = 4'd8;

// Current state variable
reg [3:0] current_state;

// Initialize current state with parameter A
initial current_state = A;

// Handle asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (1'b1)
            current_state[0]: current_state <= in? B : A;
            current_state[1]: current_state <= in? B : C;
            current_state[2]: current_state <= in? D : A;
            current_state[3]: current_state <= in? B : C;
        endcase
    end
end

// Generate output based on current state
assign out = current_state[3];

endmodule