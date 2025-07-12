module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Using 2 bits for state to make it explicit for OFF (0) and ON (1)

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case({state, j, k}) // Using a LUT-based approach
            3'b000: begin // OFF, j=0, k=0
                state <= 1'b0;
                out <= 1'b0;
            end
            3'b001: begin // OFF, j=0, k=1
                state <= 1'b0;
                out <= 1'b0;
            end
            3'b010: begin // OFF, j=1, k=0
                state <= 1'b1;
                out <= 1'b1;
            end
            3'b011: begin // OFF, j=1, k=1
                state <= 1'b1;
                out <= 1'b1;
            end
            3'b100: begin // ON, j=0, k=0
                state <= 1'b1;
                out <= 1'b1;
            end
            3'b101: begin // ON, j=0, k=1
                state <= 1'b0;
                out <= 1'b0;
            end
            3'b110: begin // ON, j=1, k=0
                state <= 1'b1;
                out <= 1'b1;
            end
            3'b111: begin // ON, j=1, k=1
                state <= 1'b0;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule