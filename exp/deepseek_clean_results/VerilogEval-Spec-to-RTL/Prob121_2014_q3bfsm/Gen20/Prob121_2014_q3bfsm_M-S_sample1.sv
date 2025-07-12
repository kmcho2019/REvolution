module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] current_state, next_state;

    // Combinational next state and output logic
    always @(*) begin
        case (current_state)
            3'b000: begin next_state = x ? 3'b001 : 3'b000; z = 0; end
            3'b001: begin next_state = x ? 3'b100 : 3'b001; z = 0; end
            3'b010: begin next_state = x ? 3'b001 : 3'b010; z = 0; end
            3'b011: begin next_state = x ? 3'b010 : 3'b001; z = 1; end
            3'b100: begin next_state = x ? 3'b100 : 3'b011; z = 1; end
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= 3'b000;
        else
            current_state <= next_state;
    end

endmodule