module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state;
parameter A = 2'b01, B = 2'b10;

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

always @(*) begin
    case (state)
        A: out <= 0;
        B: out <= 1;
        default: out <= 1;
    endcase
end

endmodule