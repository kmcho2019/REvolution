module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    parameter A = 2'b00,
              B = 2'b01,
              C = 2'b10,
              D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
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

    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule