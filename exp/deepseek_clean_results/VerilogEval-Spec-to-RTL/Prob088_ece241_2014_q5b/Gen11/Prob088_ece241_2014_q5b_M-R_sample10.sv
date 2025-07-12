module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding parameters
    parameter [1:0] STATE_A = 2'b01;
    parameter [1:0] STATE_B = 2'b10;
    
    reg [1:0] state;

    // Next state logic
    wire [1:0] next_state;
    assign next_state[0] = ~x & state[0];  // Next state_A
    assign next_state[1] = x | state[1];   // Next state_B

    // Output logic (Mealy)
    assign z = (state[0] & x) | (state[1] & ~x);

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

endmodule