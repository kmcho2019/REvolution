module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A;
    end else begin
        case (state)
            STATE_A: begin
                if (x) begin
                    state <= STATE_B;
                    z <= 1'b1;
                end else begin
                    state <= STATE_A;
                    z <= 1'b0;
                end
            end
            STATE_B: begin
                if (x) begin
                    state <= STATE_B;
                    z <= 1'b0;
                end else begin
                    state <= STATE_B;
                    z <= 1'b1;
                end
            end
            default: begin
                state <= STATE_A;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule