module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding: 1-bit state (0=OFF, 1=ON)
    reg state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        case(state)
            1'b0: begin // OFF
                out = 1'b0;
                next_state = j ? 1'b1 : 1'b0;
            end
            1'b1: begin // ON
                out = 1'b1;
                next_state = k ? 1'b0 : 1'b1;
            end
            default: begin
                out = 1'b0;
                next_state = 1'b0;
            end
        endcase
    end

    // Sequential logic: state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // OFF
        else
            state <= next_state;
    end

endmodule