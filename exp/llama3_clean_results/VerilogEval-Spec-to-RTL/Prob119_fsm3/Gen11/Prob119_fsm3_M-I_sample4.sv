module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states using one-hot encoding
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// Define the state register
reg [3:0] state;

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (1'b1)
            state[0]: state <= in ? B : A;
            state[1]: state <= in ? B : C;
            state[2]: state <= in ? D : A;
            state[3]: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
assign out = state[3];

endmodule