module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // using a single bit for two states
reg [0:0] next_state;

// State definitions
parameter B = 1'b1;
parameter A = 1'b0;

// Output logic
assign out = (state == B)? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(state)
        B: next_state = (in == 1'b0)? A : B;
        A: next_state = (in == 1'b0)? B : A;
        default: next_state = B;
    endcase
end

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

endmodule