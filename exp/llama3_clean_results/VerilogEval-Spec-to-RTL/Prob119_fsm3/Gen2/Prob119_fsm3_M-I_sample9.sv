module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
        out <= 0;
    end else begin
        case (current_state)
            A: begin
                current_state <= (in)? B : A;
                out <= 0;
            end
            B: begin
                current_state <= (in)? B : C;
                out <= 0;
            end
            C: begin
                current_state <= (in)? D : A;
                out <= 0;
            end
            D: begin
                current_state <= (in)? B : C;
                out <= 1;
            end
            default: begin
                current_state <= A;
                out <= 0;
            end
        endcase
    end
end

endmodule