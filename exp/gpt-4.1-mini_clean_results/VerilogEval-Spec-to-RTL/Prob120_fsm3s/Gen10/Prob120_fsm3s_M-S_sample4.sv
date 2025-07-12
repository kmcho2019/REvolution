module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state;

    // Sequential logic: update state on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= (in == 1'b0) ? A : B;
                B: state <= (in == 1'b0) ? C : B;
                C: state <= (in == 1'b0) ? A : D;
                D: state <= (in == 1'b0) ? C : B;
                default: state <= A;
            endcase
        end
    end

    // Moore output: 1 only in state D
    assign out = (state == D);

endmodule