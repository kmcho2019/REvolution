module TopModule(
    input       clk,
    input       reset,
    input       x,
    output reg  z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            z <= 1'b0;
        end else begin
            case(state)
                3'd0: begin
                    state <= x ? 3'd1 : 3'd0;
                    z <= 1'b0;
                end
                3'd1: begin
                    state <= x ? 3'd4 : 3'd1;
                    z <= 1'b0;
                end
                3'd2: begin
                    state <= x ? 3'd1 : 3'd2;
                    z <= 1'b0;
                end
                3'd3: begin
                    state <= x ? 3'd2 : 3'd1;
                    z <= 1'b1;
                end
                3'd4: begin
                    state <= x ? 3'd4 : 3'd3;
                    z <= 1'b1;
                end
                default: begin
                    state <= 3'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule