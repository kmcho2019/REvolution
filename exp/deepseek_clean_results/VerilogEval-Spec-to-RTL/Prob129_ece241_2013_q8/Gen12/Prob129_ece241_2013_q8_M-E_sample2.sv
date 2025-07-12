module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // One-hot encoded states
    localparam IDLE  = 3'b001;
    localparam GOT1  = 3'b010;
    localparam GOT10 = 3'b100;
    
    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = x ? GOT1 : IDLE;
            GOT1:  next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Mealy output - depends on current state and input
    assign z = (state == GOT10) & x;

endmodule