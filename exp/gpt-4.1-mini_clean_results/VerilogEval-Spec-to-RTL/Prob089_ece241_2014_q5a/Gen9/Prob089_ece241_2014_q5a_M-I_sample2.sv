module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding: 0 = waiting for first '1', 1 = inverting bits
    reg state, next_state;
    reg next_z;

    // Combinational next state and output logic
    always @(*) begin
        next_state = state;
        next_z = z;

        case (state)
            1'b0: begin
                // Waiting for first '1'
                if (x == 1'b1) begin
                    next_state = 1'b1;
                    next_z = 1'b1;  // output the first '1' bit as-is
                end else begin
                    next_state = 1'b0;
                    next_z = 1'b0;  // output zero until first '1'
                end
            end

            1'b1: begin
                // After first '1', output inverted bits
                next_state = 1'b1;
                next_z = ~x;
            end
        endcase
    end

    // Sequential state and output registers with async reset
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