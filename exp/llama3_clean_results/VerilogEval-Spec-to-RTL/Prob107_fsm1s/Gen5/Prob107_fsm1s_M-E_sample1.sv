module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-bit state variable
reg [1:0] nextState; // 2-bit next state variable

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(in) begin
                nextState = 2'b00; // State A
                out = 1'b0; // Output 0
            end else begin
                nextState = 2'b01; // State B
                out = 1'b0; // Output 0
            end
        end
        2'b01: begin // State B
            if(in) begin
                nextState = 2'b01; // State B
                out = 1'b1; // Output 1
            end else begin
                nextState = 2'b00; // State A
                out = 1'b1; // Output 1
            end
        end
        default: begin
            nextState = 2'b01; // Reset state B
            out = 1'b1; // Output 1
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b01; // Reset to state B
    end else begin
        state <= nextState; // Update state
    end
end

endmodule