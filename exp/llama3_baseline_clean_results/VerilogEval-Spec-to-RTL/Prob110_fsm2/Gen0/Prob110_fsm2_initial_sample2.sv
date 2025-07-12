module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit state variable
parameter OFF = 1'b0, ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF; // Asynchronous reset to OFF state
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default to OFF for any other state
        endcase
    end
end

always @(*) begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0; // Default output for any other state
    endcase
end

endmodule