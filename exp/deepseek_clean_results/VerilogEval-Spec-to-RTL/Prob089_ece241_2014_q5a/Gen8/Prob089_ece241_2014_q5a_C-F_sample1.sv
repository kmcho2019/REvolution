module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    wire next_state;
    wire next_z;
    
    // Combinational next-state logic
    assign next_state = (state == STATE_PASS) ? x : STATE_INVERT;
    
    // Combinational output logic
    assign next_z = (state == STATE_INVERT) ? ~x : x;
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule