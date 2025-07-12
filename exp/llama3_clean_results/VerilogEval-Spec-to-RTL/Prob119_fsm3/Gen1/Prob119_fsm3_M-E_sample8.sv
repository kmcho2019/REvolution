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

// Current state variable
reg [1:0] current_state;

// Output variable
reg out_reg;

// Initialize current state with parameter A
initial current_state = A;

// Synchronous reset and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
        endcase
    end
end

// Combinational logic to determine output
always @(*) begin
    case (current_state)
        A, B, C: out_reg = 1'd0;
        D: out_reg = 1'd1;
    endcase
end

// Assign output
assign out = out_reg;

endmodule