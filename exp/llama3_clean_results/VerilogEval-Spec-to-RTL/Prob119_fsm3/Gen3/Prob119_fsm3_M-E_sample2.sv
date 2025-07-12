module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states using one-hot encoding
parameter A = 4'd1;
parameter B = 4'd2;
parameter C = 4'd4;
parameter D = 4'd8;

// Current state variable
reg [3:0] current_state;

// Output variable
reg out_reg;

// Initialize current state with parameter A
initial current_state = A;

// Synchronous reset and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (1'b1)
            current_state[0]: current_state <= in ? B : A; // State A
            current_state[1]: current_state <= in ? B : C; // State B
            current_state[2]: current_state <= in ? D : A; // State C
            current_state[3]: current_state <= in ? B : C; // State D
        endcase
    end
end

// Combinational logic to determine output
always @(*) begin
    out_reg = current_state[3]; // Output is '1' only in state D
end

// Assign output
assign out = out_reg;

endmodule