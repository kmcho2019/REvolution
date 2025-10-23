module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state; // Binary encoding for states
reg [0:0] next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // OFF state
        out <= 0; // Explicitly set output during reset
    end else begin
        state <= next_state;
        out <= (state == 1'b1) ? 1'b1 : 1'b0; // Simplified output logic
    end
end

always @* begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // ON state
            end else begin
                next_state = 0; // OFF state
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // OFF state
            end else begin
                next_state = 1; // ON state
            end
        end
        default: begin
            next_state = 0; // OFF state (default)
        end
    endcase
end

endmodule