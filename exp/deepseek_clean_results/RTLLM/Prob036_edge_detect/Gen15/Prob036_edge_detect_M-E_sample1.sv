module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

// State encoding
localparam S00 = 2'b00; // Previous 0, current 0
localparam S01 = 2'b01; // Previous 0, current 1 (rising edge)
localparam S10 = 2'b10; // Previous 1, current 0 (falling edge)
localparam S11 = 2'b11; // Previous 1, current 1

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S00;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        state <= next_state;
        // Outputs are registered for one clock cycle
        rise <= (next_state == S01);
        down <= (next_state == S10);
    end
end

always @(*) begin
    case (state)
        S00: next_state = a ? S01 : S00;
        S01: next_state = a ? S11 : S10;
        S10: next_state = a ? S01 : S00;
        S11: next_state = a ? S11 : S10;
        default: next_state = S00;
    endcase
end

endmodule