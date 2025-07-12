module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else begin
            case(state)
                A: state <= (in == 1'b0) ? A : B;
                B: state <= (in == 1'b0) ? C : B;
                C: state <= (in == 1'b0) ? A : D;
                D: state <= (in == 1'b0) ? C : B;
                default: state <= A;
            endcase
        end
    end

    assign out = (state == D);

endmodule