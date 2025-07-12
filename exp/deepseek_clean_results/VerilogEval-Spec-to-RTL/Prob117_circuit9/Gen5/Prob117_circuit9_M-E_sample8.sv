module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot encoded states
localparam [4:0] S4 = 5'b00001,
                 S5 = 5'b00010,
                 S6 = 5'b00100,
                 S0 = 5'b01000,
                 S1 = 5'b10000;

reg [4:0] state, next_state;

// State transition logic
always @(*) begin
    case (1'b1) // synthesis parallel_case
        state[S4]: next_state = a ? S4 : S5;
        state[S5]: next_state = a ? S4 : S6;
        state[S6]: next_state = a ? S4 : S0;
        state[S0]: next_state = a ? S4 : S1;
        state[S1]: next_state = a ? S4 : S4; // Shouldn't occur per spec
        default:   next_state = S4;
    endcase
end

// State register and output assignment
always @(posedge clk) begin
    state <= next_state;
    
    case (1'b1) // synthesis parallel_case
        next_state[S4]: q <= 3'd4;
        next_state[S5]: q <= 3'd5;
        next_state[S6]: q <= 3'd6;
        next_state[S0]: q <= 3'd0;
        next_state[S1]: q <= 3'd1;
        default:       q <= 3'd4;
    endcase
end

// Initial state
initial begin
    state = S4;
    q = 3'd4;
end

endmodule