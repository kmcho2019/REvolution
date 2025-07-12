module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state;

    // State register update and next state logic combined
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= (w == 1'b0) ? B : A;
                B: state <= (w == 1'b0) ? C : D;
                C: state <= (w == 1'b0) ? E : D;
                D: state <= (w == 1'b0) ? F : A;
                E: state <= (w == 1'b0) ? E : D;
                F: state <= (w == 1'b0) ? C : D;
                default: state <= A;
            endcase
        end
    end

    // Output logic
    assign z = (state == E) || (state == F);

endmodule