module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    localparam [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case(state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A;
            endcase
        end
    end

    always @(*) begin
        case(state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule