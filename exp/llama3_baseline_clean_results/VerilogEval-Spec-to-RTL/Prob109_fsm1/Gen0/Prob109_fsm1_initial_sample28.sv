module TopModule (
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg [0:0] state; // 1-bit register to store the current state
parameter A = 1'b0, B = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            A: begin
                if (in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B;
        endcase
    end
end

assign out = (state == B) ? 1'b1 : 1'b0;

endmodule