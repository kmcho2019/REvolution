module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

localparam STATE_B = 1'b1;
localparam STATE_A = 1'b0;

reg current_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= STATE_B;
    end else begin
        case(current_state)
            STATE_B: begin
                if(in == 1'b0) begin
                    current_state <= STATE_A;
                end else begin
                    current_state <= STATE_B;
                end
            end
            STATE_A: begin
                if(in == 1'b0) begin
                    current_state <= STATE_B;
                end else begin
                    current_state <= STATE_A;
                end
            end
            default: current_state <= STATE_B;
        endcase
    end
end

always @(*) begin
    case(current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'bx; // Unknown state
    endcase
end

endmodule