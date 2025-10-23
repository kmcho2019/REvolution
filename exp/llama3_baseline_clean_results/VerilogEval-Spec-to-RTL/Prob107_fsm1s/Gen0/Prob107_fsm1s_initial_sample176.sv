module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // State register (B = 0, A = 1)
reg [1:0] next_state; // Next state register

// State encoding
parameter B = 0;
parameter A = 1;

// Initial state is B
initial state = B;

// Next state logic
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        B: begin
            if(in == 0) next_state = A;
            else next_state = B;
            out = 1; // out = 1 for state B
        end
        A: begin
            if(in == 0) next_state = B;
            else next_state = A;
            out = 0; // out = 0 for state A
        end
        default: next_state = B; // Default to state B
    endcase
end

endmodule