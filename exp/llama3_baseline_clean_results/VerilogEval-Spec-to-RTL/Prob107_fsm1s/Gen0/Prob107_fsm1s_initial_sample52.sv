module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Using 1 bit to represent the two states
reg [0:0] next_state;

// State definition
parameter B = 1'b0;
parameter A = 1'b1;

// Output logic
always @(state) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Next state logic
always @(state, in) begin
    case(state)
        B: begin
            if(in == 1'b0)
                next_state = B;
            else
                next_state = B;
            end
        A: begin
            if(in == 1'b0)
                next_state = B;
            else
                next_state = A;
            end
    endcase
end

// State register
always @(posedge clk) begin
    if(reset == 1'b1)
        state <= B;
    else
        state <= next_state;
end

endmodule