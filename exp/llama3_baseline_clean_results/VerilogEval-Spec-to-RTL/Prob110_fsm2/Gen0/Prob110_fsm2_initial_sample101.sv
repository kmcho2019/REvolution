module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] current_state; // 2 states can be represented with 2 bits
parameter OFF = 2'b00, ON = 2'b01;

always @(*) begin
    case(current_state)
        OFF: begin
            if (j) begin
                out = 0;
            end else begin
                out = 0;
            end
        end
        ON: begin
            if (k) begin
                out = 1;
            end else begin
                out = 1;
            end
        end
        default: out = 1'bx; // Invalid state, assign don't care
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case(current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF; // Default to OFF on invalid state
        endcase
    end
end

endmodule