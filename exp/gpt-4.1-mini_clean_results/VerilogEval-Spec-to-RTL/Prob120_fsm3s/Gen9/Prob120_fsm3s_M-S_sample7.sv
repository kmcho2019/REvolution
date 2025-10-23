module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= (in) ? B : A;
                B: state <= (in) ? B : C;
                C: state <= (in) ? D : A;
                D: state <= (in) ? B : C;
                default: state <= A;
            endcase
        end
    end

    // Moore output: depends only on current state
    always @(*) begin
        out = (state == D) ? 1'b1 : 1'b0;
    end

endmodule