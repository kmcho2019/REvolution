module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // Using a 1-bit register to represent the state
reg [0:0] next_state;

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: begin // State B
            out = 1;
            if(in == 0) begin
                next_state = 1; // Go to state A
            end else begin
                next_state = 0; // Stay in state B
            end
        end
        1: begin // State A
            out = 0;
            if(in == 0) begin
                next_state = 0; // Go to state B
            end else begin
                next_state = 1; // Stay in state A
            end
        end
        default: next_state = 0; // Default to state B
    endcase
end

endmodule