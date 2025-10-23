module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

reg current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        case (current_state)
            A: begin
                if (in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: current_state <= B;
        endcase
    end
end

always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 1;
        default: out = 1'b0;
    endcase
end

endmodule