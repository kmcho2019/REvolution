module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // States: 2'b00 - A, 2'b01 - B_eval1, 2'b10 - B_eval2, 2'b11 - B_eval3
reg [1:0] w_count; // Count of w = 1 in the evaluation cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to state B_eval1
                    w_count <= 2'b00;
                end
            end
            2'b01: begin // State B_eval1
                if (w) begin
                    w_count <= w_count + 1;
                end
                state <= 2'b10; // Move to state B_eval2
            end
            2'b10: begin // State B_eval2
                if (w) begin
                    w_count <= w_count + 1;
                end
                state <= 2'b11; // Move to state B_eval3
            end
            2'b11: begin // State B_eval3
                if (w) begin
                    w_count <= w_count + 1;
                end
                // Evaluate the condition for z
                if (w_count == 2'b10) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                state <= 2'b01; // Loop back to B_eval1 for next evaluation
                w_count <= 2'b00; // Reset w_count for next evaluation
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule