module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            C: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= D;
                end
            end
            D: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            default: state <= A;
        endcase
    end
end

always @(*) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule