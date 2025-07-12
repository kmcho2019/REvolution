module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
reg [0:0] state;  // 1-bit state register, 0 represents state A, 1 represents state B
reg [0:0] next_state;  // 1-bit next state register

// Output logic
always @(*) begin
    case (state)
        1'b0: out = 1'b0;  // State A, out = 0
        1'b1: out = 1'b1;  // State B, out = 1
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(*) begin
    if (reset) begin
        next_state = 1'b1;  // Reset state is B (out=1)
    end else begin
        case (state)
            1'b0: begin
                if (~in) next_state = 1'b1;  // A (out=0) --in=0--> B
                else    next_state = 1'b0;  // A (out=0) --in=1--> A
            end
            1'b1: begin
                if (~in) next_state = 1'b1;  // B (out=1) --in=0--> B
                else    next_state = 1'b1;  // B (out=1) --in=1--> B
            end
            default: next_state = 1'b1;
        endcase
    end
end

// State register
always @(posedge clk) begin
    state <= next_state;
end

endmodule