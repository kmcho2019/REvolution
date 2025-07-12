module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg current_state;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        case (current_state)
            1'b0: begin // State A
                case (in)
                    1'b0: current_state <= 1'b1; // A -> B on in = 0
                    1'b1: current_state <= 1'b0; // A -> A on in = 1
                endcase
            end
            1'b1: begin // State B
                case (in)
                    1'b0: current_state <= 1'b0; // B -> A on in = 0
                    1'b1: current_state <= 1'b1; // B -> B on in = 1
                endcase
            end
        endcase
    end
end

assign out = current_state;

endmodule