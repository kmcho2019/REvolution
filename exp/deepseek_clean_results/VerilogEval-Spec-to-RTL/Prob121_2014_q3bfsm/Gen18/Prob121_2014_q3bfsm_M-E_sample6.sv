module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    reg [2:0] next_state_0, next_state_1;
    reg next_z;

    // Parallel next state computation for both x cases
    always @(*) begin
        case (state)
            3'b000: begin next_state_0 = 3'b000; next_state_1 = 3'b001; next_z = 1'b0; end
            3'b001: begin next_state_0 = 3'b001; next_state_1 = 3'b100; next_z = 1'b0; end
            3'b010: begin next_state_0 = 3'b010; next_state_1 = 3'b001; next_z = 1'b0; end
            3'b011: begin next_state_0 = 3'b001; next_state_1 = 3'b010; next_z = 1'b1; end
            3'b100: begin next_state_0 = 3'b011; next_state_1 = 3'b100; next_z = 1'b1; end
            default: begin next_state_0 = 3'b000; next_state_1 = 3'b000; next_z = 1'b0; end
        endcase
    end

    // Sequential logic with output prediction
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            state <= x ? next_state_1 : next_state_0;
            z <= next_z;
        end
    end

endmodule