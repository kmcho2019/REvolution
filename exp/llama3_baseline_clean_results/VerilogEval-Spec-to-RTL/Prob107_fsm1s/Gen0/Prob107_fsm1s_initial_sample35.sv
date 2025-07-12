module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Current state (A=0, B=1)
reg [0:0] next_state; // Next state

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

// Output logic
always @(*) begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b1;
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if(!in) next_state = B;
            else next_state = A;
        end
        B: begin
            if(!in) next_state = A;
            else next_state = B;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end
    else begin
        state <= next_state;
    end
end

endmodule