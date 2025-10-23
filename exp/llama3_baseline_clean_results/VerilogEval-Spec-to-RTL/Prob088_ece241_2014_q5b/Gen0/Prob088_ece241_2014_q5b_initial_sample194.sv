module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot encoding for states A and B
parameter A = 2'b01;
parameter B = 2'b10;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        case(state)
            A: begin
                if(x) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                state <= B; // regardless of x, stay in B
            end
            default: state <= A; // default case for unused states
        endcase
    end
end

always @(*) begin
    case(state)
        A: z = ~x;
        B: z = x;
        default: z = 1'b0; // default case for unused states
    endcase
end

endmodule