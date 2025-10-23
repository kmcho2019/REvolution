module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Using 2 bits for one-hot, though only one bit is needed for two states
parameter A = 1'b1; // State A
parameter B = 1'b0; // State B

always @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset to state A
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
                if(x) begin
                    state <= B;
                end else begin
                    state <= B;
                end
            end
            default: state <= A; // Default to state A
        endcase
    end
end

always @(*) begin
    case(state)
        A: z = ~x;
        B: z = x;
        default: z = 1'bx; // Default output to avoid latches
    endcase
end

endmodule