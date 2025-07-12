module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Combinational logic to determine next state and output z
always @(*)
begin
    case (current_state)
        A: 
            if (~x) 
                next_state = A;
            else 
                next_state = B;
            if (~x) 
                z = 1'b0;
            else 
                z = 1'b1;
        B: 
            next_state = B;
            if (~x) 
                z = 1'b1;
            else 
                z = 1'b0;
        default: 
            next_state = A;
            z = 1'b0;
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) 
        current_state <= A;
    else 
        current_state <= next_state;
end

endmodule