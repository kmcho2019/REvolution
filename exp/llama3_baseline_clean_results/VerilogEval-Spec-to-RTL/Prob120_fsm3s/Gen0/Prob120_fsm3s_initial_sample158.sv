module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg[1:0] current_state, next_state;

// Output logic (Moore machine)
assign out = (current_state == D) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule