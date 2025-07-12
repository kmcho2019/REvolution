module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    // 0: Before first '1' encountered
    // 1: After first '1' encountered
    reg state, next_state;
    reg next_z;

    // Combinational next state and output logic
    always @(*) begin
        case (state)
            1'b0: begin
                next_z = x;           // Output input bit directly until first '1'
                next_state = x ? 1'b1 : 1'b0; // Transition to state 1 on first '1'
            end
            1'b1: begin
                next_z = ~x;          // Invert input bits after first '1'
                next_state = 1'b1;
            end
            default: begin
                next_z = 1'b0;
                next_state = 1'b0;
            end
        endcase
    end

    // Sequential state and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule