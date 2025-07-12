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

// Define next state lookup table
parameter [1:0] next_state_lut [4:0] = '{A, B, C, A, D};

// Define output lookup table
parameter [0:0] output_lut [4:0] = '{1'd0, 1'd0, 1'd0, 1'd1, 1'd1};

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
    end else if (~in) begin
        case (current_state)
            A: current_state <= A;
            B: current_state <= C;
            C: current_state <= A;
            D: current_state <= C;
        endcase
    end else begin
        case (current_state)
            A: current_state <= B;
            B: current_state <= B;
            C: current_state <= D;
            D: current_state <= B;
        endcase
    end
end

// Combinational logic to determine output
always @(*) begin
    case (current_state)
        A: out_reg = 1'd0;
        B: out_reg = 1'd0;
        C: out_reg = 1'd0;
        D: out_reg = 1'd1;
    endcase
end

// Assign output
assign out = out_reg;

endmodule