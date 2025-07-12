module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 1'b0, B = 1'b1;

reg current_state;
reg next_state;

// Output logic (Moore machine, output depends only on state)
always_comb begin
    case (current_state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b0; // Default to avoid latch inference
    endcase
end

// State transition logic
always_comb begin
    case (current_state)
        A: begin
            if (in == 1'b1) next_state = A;
            else next_state = B;
        end
        B: begin
            if (in == 1'b1) next_state = B;
            else next_state = A;
        end
        default: next_state = B; // Default to reset state
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

endmodule