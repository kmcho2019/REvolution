module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 0: state B, 1: state A
reg [0:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state B
    end else begin
        case(state)
            0: begin // State B
                if(!in) begin
                    next_state <= 1; // Go to state A
                end else begin
                    next_state <= 0; // Stay in state B
                end
            end
            1: begin // State A
                if(!in) begin
                    next_state <= 0; // Go to state B
                end else begin
                    next_state <= 1; // Stay in state A
                end
            end
        endcase
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: out = 1; // State B, out = 1
        1: out = 0; // State A, out = 0
    endcase
end

endmodule