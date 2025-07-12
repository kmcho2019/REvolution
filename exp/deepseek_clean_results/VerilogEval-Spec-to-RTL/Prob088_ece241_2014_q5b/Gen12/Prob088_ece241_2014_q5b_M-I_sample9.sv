module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Explicit state encoding (binary since only 2 states)
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;  // Current state

    // Next state and output calculation
    wire next_state;
    wire next_z;
    
    assign next_state = (state == STATE_A) ? (x ? STATE_B : STATE_A) : STATE_B;
    assign next_z = (state == STATE_A) ? x : ~x;

    // State and output update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule