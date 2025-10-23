module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] state;
    wire      clk_en = ~start_shifting;  // Clock gating for power optimization

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            start_shifting <= 1'b0;
        end else if (clk_en) begin
            case (state)
                3'b000: state <= data ? 3'b001 : 3'b000;  // Wait for first '1'
                3'b001: state <= data ? 3'b010 : 3'b000;  // Got '1', wait for second '1'
                3'b010: state <= data ? 3'b010 : 3'b011;  // Got '11', wait for '0'
                3'b011: begin                             // Got '110', wait for final '1'
                    if (data) begin
                        state <= 3'b100;
                        start_shifting <= 1'b1;
                    end else begin
                        state <= 3'b000;
                    end
                end
                // 3'b100: FOUND state - no state change needed
            endcase
        end
    end

endmodule