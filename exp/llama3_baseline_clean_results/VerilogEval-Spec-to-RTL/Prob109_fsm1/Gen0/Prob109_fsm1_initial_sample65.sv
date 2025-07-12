`define STATE_A 1'b0
`define STATE_B 1'b1

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg current_state, next_state;

always @(*) begin
    case(current_state)
        `STATE_A: begin
            if (in) begin
                next_state = `STATE_A;
            end else begin
                next_state = `STATE_B;
            end
        end
        `STATE_B: begin
            if (in) begin
                next_state = `STATE_B;
            end else begin
                next_state = `STATE_A;
            end
        end
        default: begin
            next_state = `STATE_B;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= `STATE_B;
    end else begin
        current_state <= next_state;
    end
end

assign out = (current_state == `STATE_B) ? 1'b1 : 1'b0;

endmodule