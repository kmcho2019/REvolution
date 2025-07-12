module TopModule(
    input        clk,
    input        areset,
    input        x,
    output       z
);

reg [1:0] state;
reg [1:0] next_state;

// Define the states
parameter A = 2'b01;
parameter B = 2'b10;

// Output logic
assign z = (state == A) ? ~x : x;

// Next state logic
always @(*) begin
    case(state)
        A: next_state = (x == 0) ? A : B;
        B: next_state = B;
        default: next_state = A;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule