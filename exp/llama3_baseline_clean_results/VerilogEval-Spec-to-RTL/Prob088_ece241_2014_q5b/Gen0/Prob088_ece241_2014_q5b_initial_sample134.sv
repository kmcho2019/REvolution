module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Define states
localparam STATE_A = 2'b10;
localparam STATE_B = 2'b01;

always @(posedge clk or posedge areset)
begin
    if (areset) 
        state <= STATE_A;
    else 
        state <= next_state;
end

always @(*)
begin
    case (state)
        STATE_A: 
            if (x == 1'b0) 
                next_state = STATE_A;
            else 
                next_state = STATE_B;

            if (x == 1'b0) 
                z = 1'b0;
            else 
                z = 1'b1;

        STATE_B: 
            next_state = STATE_B;

            if (x == 1'b0) 
                z = 1'b1;
            else 
                z = 1'b0;

        default: 
            next_state = STATE_A;
            z = 1'b0;
    endcase
end

endmodule