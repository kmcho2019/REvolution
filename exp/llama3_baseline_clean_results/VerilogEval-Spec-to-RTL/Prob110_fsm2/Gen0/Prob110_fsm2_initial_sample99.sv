module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Using 1 bit for two states: 0 - OFF, 1 - ON

always @(*) begin
    if (areset) begin
        state = 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin
                if (j) begin
                    state = 1; // Transition from OFF to ON on j=1
                end else begin
                    state = 0; // Stay in OFF on j=0
                end
            end
            1: begin
                if (k) begin
                    state = 0; // Transition from ON to OFF on k=1
                end else begin
                    state = 1; // Stay in ON on k=0
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (areset) begin
        out <= 0; // Reset output
    end else begin
        case (state)
            0: out <= 0; // Output 0 in OFF state
            1: out <= 1; // Output 1 in ON state
        endcase
    end
end

endmodule