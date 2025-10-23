module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next state logic for y[1]
always @(y, w) begin
    case (y)
        3'b000: begin // State A
            if (~w) begin
                y[1] <= 1'b1; // Go to state B
            end else begin
                y[1] <= 1'b0; // Stay in state A
            end
        end
        3'b001: begin // State B
            if (~w) begin
                y[1] <= 1'b0; // Go to state C
            end else begin
                y[1] <= 1'b1; // Go to state D
            end
        end
        3'b010: begin // State C
            if (~w) begin
                y[1] <= 1'b1; // Go to state E
            end else begin
                y[1] <= 1'b1; // Go to state D
            end
        end
        3'b011: begin // State D
            if (~w) begin
                y[1] <= 1'b0; // Go to state F
            end else begin
                y[1] <= 1'b0; // Go to state A
            end
        end
        3'b100: begin // State E
            if (w) begin
                y[1] <= 1'b1; // Stay in state E
            end else begin
                y[1] <= 1'b1; // Go to state D
            end
        end
        3'b101: begin // State F
            if (w) begin
                y[1] <= 1'b0; // Go to state C
            end else begin
                y[1] <= 1'b1; // Go to state D
            end
        end
        default: begin
            y[1] <= 1'b0; // Default state
        end
    endcase
end

endmodule