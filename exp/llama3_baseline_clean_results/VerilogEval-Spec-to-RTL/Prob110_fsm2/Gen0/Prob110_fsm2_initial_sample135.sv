module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // Using 2 bits for two states: OFF and ON
parameter OFF = 2'b00, ON = 2'b01;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) state <= ON;
                else state <= OFF;
            end
            ON: begin
                if (k) state <= OFF;
                else state <= ON;
            end
            default: state <= OFF;
        endcase
    end
end

always @ (*) begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule