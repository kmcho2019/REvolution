module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    reg [2:0] next_state;
    reg next_z;

    // ROM implementation for next state and output
    always @(*) begin
        case ({state, x})
            4'b0000: begin next_state = 3'b000; next_z = 0; end
            4'b0001: begin next_state = 3'b001; next_z = 0; end
            4'b0010: begin next_state = 3'b001; next_z = 0; end
            4'b0011: begin next_state = 3'b100; next_z = 0; end
            4'b0100: begin next_state = 3'b010; next_z = 0; end
            4'b0101: begin next_state = 3'b001; next_z = 0; end
            4'b0110: begin next_state = 3'b001; next_z = 1; end
            4'b0111: begin next_state = 3'b010; next_z = 1; end
            4'b1000: begin next_state = 3'b011; next_z = 1; end
            4'b1001: begin next_state = 3'b100; next_z = 1; end
            default: begin next_state = 3'b000; next_z = 0; end
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule