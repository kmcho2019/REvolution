module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state; // 2 states, so 2 bits are sufficient, but we'll use only 2 values (0 for A, 1 for B)
reg [1:0] next_state;

// Output logic
always @(*) begin
    case(state)
        2'b01: out = 1'b0; // State A
        2'b10: out = 1'b1; // State B
        default: out = 1'b1; // Default state (to avoid latch)
    endcase
end

// State transition logic
always @(posedge clk) begin
    if(reset) begin // Active-high synchronous reset
        state <= 2'b10; // Reset to state B
    end else begin
        case(state)
            2'b01: begin // State A
                if(!in) begin
                    state <= 2'b10; // A to B when in=0
                end else begin
                    state <= 2'b01; // Stay in A when in=1
                end
            end
            2'b10: begin // State B
                if(!in) begin
                    state <= 2'b01; // B to A when in=0
                end else begin
                    state <= 2'b10; // Stay in B when in=1
                end
            end
            default: state <= 2'b10; // Default to state B
        endcase
    end
end

initial begin
    state = 2'b10; // Initialize state to B
end

endmodule