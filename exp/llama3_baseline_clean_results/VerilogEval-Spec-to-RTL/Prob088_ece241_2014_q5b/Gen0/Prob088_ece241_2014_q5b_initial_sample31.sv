module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

always @(*) begin
    case(state)
        A: 
            if(x) 
                next_state = B;
            else 
                next_state = A;
            z = 1'b0;
        B: 
            if(x) 
                next_state = B;
            else 
                next_state = B;
            z = 1'b1;
        default: 
            next_state = A;
            z = 1'b0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) 
        state <= A;
    else 
        state <= next_state;
end

endmodule