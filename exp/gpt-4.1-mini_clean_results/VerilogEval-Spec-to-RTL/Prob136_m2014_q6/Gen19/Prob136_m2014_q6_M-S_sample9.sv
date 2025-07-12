module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (w == 1'b0) state <= B;
                    else state <= A;
                    z <= 1'b0;
                end
                B: begin
                    if (w == 1'b0) state <= C;
                    else state <= D;
                    z <= 1'b0;
                end
                C: begin
                    if (w == 1'b0) state <= E;
                    else state <= D;
                    z <= 1'b0;
                end
                D: begin
                    if (w == 1'b0) state <= F;
                    else state <= A;
                    z <= 1'b0;
                end
                E: begin
                    if (w == 1'b0) state <= E;
                    else state <= D;
                    z <= 1'b1;
                end
                F: begin
                    if (w == 1'b0) state <= C;
                    else state <= D;
                    z <= 1'b1;
                end
                default: begin
                    state <= A;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule