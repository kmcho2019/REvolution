module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == D);
    end

endmodule