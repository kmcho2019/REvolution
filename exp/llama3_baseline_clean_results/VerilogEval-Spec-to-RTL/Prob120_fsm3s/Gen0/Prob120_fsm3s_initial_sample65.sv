module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(state) begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// State transition logic
always @(state, in) begin
    case(state)
        A: next_state = (in == 1'b0)? A : B;
        B: next_state = (in == 1'b0)? C : B;
        C: next_state = (in == 1'b0)? A : D;
        D: next_state = (in == 1'b0)? C : B;
    endcase
end

// State update on positive edge of clock
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule