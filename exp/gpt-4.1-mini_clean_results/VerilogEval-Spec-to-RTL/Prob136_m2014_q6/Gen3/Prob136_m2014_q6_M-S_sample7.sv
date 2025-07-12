module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: state <= (w == 0) ? B : A;
                B: state <= (w == 0) ? C : D;
                C: state <= (w == 0) ? E : D;
                D: state <= (w == 0) ? F : A;
                E: state <= (w == 0) ? E : D;
                F: state <= (w == 0) ? C : D;
                default: state <= A;
            endcase
            z <= (state == E || state == F);
        end
    end

endmodule