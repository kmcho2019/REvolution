module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    reg [2:0] state;

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= (w == 1'b0) ? B : A;
                    z <= 1'b0;
                end
                B: begin
                    state <= (w == 1'b0) ? C : D;
                    z <= 1'b0;
                end
                C: begin
                    state <= (w == 1'b0) ? E : D;
                    z <= 1'b0;
                end
                D: begin
                    state <= (w == 1'b0) ? F : A;
                    z <= 1'b0;
                end
                E: begin
                    state <= (w == 1'b0) ? E : D;
                    z <= 1'b1;
                end
                F: begin
                    state <= (w == 1'b0) ? C : D;
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