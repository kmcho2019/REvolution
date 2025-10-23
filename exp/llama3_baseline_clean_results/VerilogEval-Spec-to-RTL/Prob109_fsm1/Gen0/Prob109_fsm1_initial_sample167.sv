module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;
reg current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_B;
    end else begin
        case (current_state)
            STATE_B: begin
                if (in) begin
                    current_state <= STATE_B;
                end else begin
                    current_state <= STATE_A;
                end
            end
            STATE_A: begin
                if (in) begin
                    current_state <= STATE_A;
                end else begin
                    current_state <= STATE_B;
                end
            end
            default: current_state <= STATE_B;
        endcase
    end
end

always @(*) begin
    case (current_state)
        STATE_A: out = 1'b0;
        STATE_B: out = 1'b1;
        default: out = 1'b1; // Default to STATE_B output if not explicitly handled
    endcase
end

endmodule