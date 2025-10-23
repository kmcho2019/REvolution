module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin // Reset
        state <= 3'b000; // State A
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= nextState;
        case (state)
            3'b000: begin // State A
                f <= 1'b0;
                g <= 1'b0;
            end
            3'b001: begin // State B
                f <= 1'b1;
                g <= 1'b0;
            end
            3'b010: begin // State C
                f <= 1'b0;
                g <= 1'b0;
            end
            3'b011: begin // State D
                f <= 1'b0;
                g <= 1'b1;
            end
            3'b100: begin // State E
                f <= 1'b0;
                g <= 1'b1;
            end
            3'b101: begin // State F
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        3'b000: begin // State A
            if (resetn) begin
                nextState = 3'b001; // Move to state B
            end else begin
                nextState = 3'b000; // Stay in state A
            end
        end
        3'b001: begin // State B
            nextState = 3'b010; // Move to state C
        end
        3'b010: begin // State C
            reg [1:0] seq; // Sequence detector for x
            if (x) begin
                seq = {1'b1, seq[1]};
            end else begin
                seq = {1'b0, seq[1]};
            end
            if (seq == 2'b101) begin
                nextState = 3'b011; // Move to state D
            end else begin
                nextState = 3'b010; // Stay in state C
            end
        end
        3'b011: begin // State D
            reg [1:0] count; // Counter for y
            if (y) begin
                nextState = 3'b100; // Move to state E
            end else if (count == 2'b10) begin
                nextState = 3'b101; // Move to state F
            end else begin
                count = count + 1'b1;
                nextState = 3'b011; // Stay in state D
            end
        end
        3'b100: begin // State E
            nextState = 3'b100; // Stay in state E
        end
        3'b101: begin // State F
            nextState = 3'b101; // Stay in state F
        end
    endcase
end

endmodule