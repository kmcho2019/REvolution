module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // Using 2 bits to represent two states (B and A)
parameter B = 2'b00, A = 2'b01;

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        state <= B;
    end else begin
        case (state)
            B: begin
                if (!in) begin // in = 0
                    state <= A;
                end else begin // in = 1
                    state <= B;
                end
            end
            A: begin
                if (!in) begin // in = 0
                    state <= B;
                end else begin // in = 1
                    state <= A;
                end
            end
            default: state <= B; // Default to state B
        endcase
    end
end

// Output logic based on the current state (Moore machine characteristic)
always @(state) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0; // Default output to 0 for any unexpected state
    endcase
end

endmodule