module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define the states
reg [0:0] state;

// State transition and output logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out <= 1'b0;
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1;
                    out <= 1'b1;
                end else begin
                    state <= 0;
                    out <= 1'b0;
                end
            end
            1: begin // ON state
                if (~k) begin
                    state <= 1;
                    out <= 1'b1;
                end else begin
                    state <= 0;
                    out <= 1'b0;
                end
            end
        endcase
    end
end

endmodule