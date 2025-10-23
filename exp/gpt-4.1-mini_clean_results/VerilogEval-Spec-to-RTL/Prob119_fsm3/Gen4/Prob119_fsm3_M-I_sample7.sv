module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
            out <= state[1]; // MSB of state is '1' only in state D
        end
    end

endmodule