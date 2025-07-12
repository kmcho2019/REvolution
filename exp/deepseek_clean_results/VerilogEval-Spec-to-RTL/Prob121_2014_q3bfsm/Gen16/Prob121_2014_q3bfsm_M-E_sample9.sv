module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    reg [2:0] state;
    wire [2:0] next_state_0, next_state_1;
    wire [2:0] next_state;

    // Parallel next state computation for x=0
    assign next_state_0 = (state == 3'b000) ? 3'b000 :
                         (state == 3'b001) ? 3'b001 :
                         (state == 3'b010) ? 3'b010 :
                         (state == 3'b011) ? 3'b001 :
                         (state == 3'b100) ? 3'b011 :
                         3'b000;  // default case

    // Parallel next state computation for x=1
    assign next_state_1 = (state == 3'b000) ? 3'b001 :
                         (state == 3'b001) ? 3'b100 :
                         (state == 3'b010) ? 3'b001 :
                         (state == 3'b011) ? 3'b010 :
                         (state == 3'b100) ? 3'b100 :
                         3'b000;  // default case

    // Select next state based on input x
    assign next_state = x ? next_state_1 : next_state_0;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic (z=1 for states 011 and 100)
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule