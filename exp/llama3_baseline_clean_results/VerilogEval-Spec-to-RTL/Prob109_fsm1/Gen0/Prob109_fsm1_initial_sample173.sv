module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 0: A, 1: B
parameter A = 0, B = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            A: begin
                if (~in)
                    state <= B;
                else
                    state <= A;
            end
            B: begin
                if (in)
                    state <= B;
                else
                    state <= A;
            end
            default: state <= B;
        endcase
    end
end

assign out = (state == B) ? 1'b1 : 1'b0;

endmodule