module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state; // 1 bit for two states A and B

// Define states
localparam STATE_A = 0;
localparam STATE_B = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state B
        current_state <= STATE_B;
    end else begin
        // State transitions
        case (current_state)
            STATE_B: begin
                if (in) begin
                    // From B with in=1, stay in B
                    current_state <= STATE_B;
                end else begin
                    // From B with in=0, go to A
                    current_state <= STATE_A;
                end
            end
            STATE_A: begin
                if (in) begin
                    // From A with in=1, stay in A
                    current_state <= STATE_A;
                end else begin
                    // From A with in=0, go to B
                    current_state <= STATE_B;
                end
            end
        endcase
    end
end

// Output logic
assign out = (current_state == STATE_B)? 1'b1 : 1'b0;

endmodule