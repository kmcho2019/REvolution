module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
localparam S_B = 1'b1; // State B
localparam S_A = 1'b0; // State A

reg [0:0] current_state;
reg [0:0] next_state;

// Output logic: Output depends solely on the state in a Moore machine
always_comb begin
    case (current_state)
        S_B: out = 1'b1;
        S_A: out = 1'b0;
        default: out = 1'bx; // Default to unknown for invalid states
    endcase
end

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= S_B; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        S_B: begin
            if (in == 1'b1) begin
                next_state = S_B;
            end else begin
                next_state = S_A;
            end
        end
        S_A: begin
            if (in == 1'b1) begin
                next_state = S_A;
            end else begin
                next_state = S_B;
            end
        end
        default: next_state = S_B; // Default to state B for invalid states
    endcase
end

endmodule