module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Define the one-hot encodings for the states
localparam A = 2'b01;
localparam B = 2'b10;

// Next state logic
always @(*) begin
    case(state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0;
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