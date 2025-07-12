module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // State variable

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state B
        out <= 1'b1;
    end else begin
        case(state)
            1'b0: begin
                if(in) state <= 1'b0;
                else state <= 1'b1;
                out <= 1'b1;
            end
            1'b1: begin
                if(in) state <= 1'b1;
                else state <= 1'b0;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule