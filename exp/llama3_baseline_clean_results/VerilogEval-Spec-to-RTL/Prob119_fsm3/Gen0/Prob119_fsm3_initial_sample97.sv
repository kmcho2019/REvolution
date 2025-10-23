module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Define the next state logic
always @(*) begin
    case(state)
        A: begin
            if (!in)
                next_state = A;
            else
                next_state = B;
        end
        B: begin
            if (!in)
                next_state = C;
            else
                next_state = B;
        end
        C: begin
            if (!in)
                next_state = A;
            else
                next_state = D;
        end
        D: begin
            if (!in)
                next_state = C;
            else
                next_state = B;
        end
    endcase
end

// Define the output logic
assign out = (state == D) ? 1'b1 : 1'b0;

// Define the state register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule