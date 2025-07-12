module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using binary encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
        out <= 1'b1; // Reset output to 1
    end else begin
        case(state)
            STATE_B: begin
                if(!in) begin
                    state <= STATE_A;
                    out <= 1'b0;
                end else begin
                    state <= STATE_B;
                    out <= 1'b1;
                end
            end
            STATE_A: begin
                if(!in) begin
                    state <= STATE_B;
                    out <= 1'b1;
                end else begin
                    state <= STATE_A;
                    out <= 1'b0;
                end
            end
            default: begin
                state <= STATE_B; // Default state
                out <= 1'b1;
            end
        endcase
    end
end

endmodule