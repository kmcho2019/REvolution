module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 1-bit variable to represent the state
parameter B = 1'b1; // State B
parameter A = 1'b0; // State A

always @ (posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= B;
    end else begin
        case(state)
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B; // Default to state B on any other state
        endcase
    end
end

always @ (*)
begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // Default output to 1 on any other state
    endcase
end

endmodule