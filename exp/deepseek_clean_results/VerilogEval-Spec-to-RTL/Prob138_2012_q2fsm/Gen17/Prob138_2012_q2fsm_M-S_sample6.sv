module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    parameter A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;
    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) state <= A;
        else case (state)
            A: state <= w ? B : A;
            B: state <= w ? C : D;
            C: state <= w ? E : D;
            D: state <= w ? F : A;
            E: state <= w ? E : D;
            F: state <= w ? C : D;
            default: state <= A;
        endcase
    end

    assign z = (state == E) | (state == F);

endmodule