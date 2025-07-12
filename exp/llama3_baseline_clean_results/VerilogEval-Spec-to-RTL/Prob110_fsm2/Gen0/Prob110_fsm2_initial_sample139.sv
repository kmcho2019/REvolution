module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
reg [1:0] state;
parameter OFF = 2'b00, ON = 2'b01;

// Initialize output
reg out;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to OFF state
        state <= OFF;
        out <= 1'b0;
    end else begin
        case(state)
            OFF: begin
                if (j) begin
                    state <= ON;
                    out <= 1'b1;
                end else begin
                    state <= OFF;
                    out <= 1'b0;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                    out <= 1'b0;
                end else begin
                    state <= ON;
                    out <= 1'b1;
                end
            end
            default: begin
                state <= OFF;
                out <= 1'b0;
            end
        endcase
    end
end

assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule