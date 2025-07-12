module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define states
parameter A = 1'b1;
parameter B = 1'b10;
parameter C = 1'b100;
parameter D = 1'b1000;

// Current state variable
reg [3:0] current_state;

// Initialize current state with parameter A
initial current_state = A;

// Handle asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in? B : A;
            B: current_state <= in? B : C;
            C: current_state <= in? D : A;
            D: current_state <= in? B : C;
            default: current_state <= A;
        endcase
    end
end

// Generate output based on current state
assign out = (current_state == D);

endmodule