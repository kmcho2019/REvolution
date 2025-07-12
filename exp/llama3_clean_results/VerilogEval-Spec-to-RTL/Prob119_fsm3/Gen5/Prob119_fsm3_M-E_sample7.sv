module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 3'b001;
parameter B = 3'b010;
parameter C = 3'b100;
parameter D = 3'b011;

// Current state variable
reg [2:0] current_state;

// Initialize current state with parameter A
initial current_state = A;

// Synchronous reset and sequential logic
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

// Combinational logic to determine output
assign out = current_state == D;

endmodule