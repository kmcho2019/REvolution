module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 3-bit state variable
reg [2:0] nextState; // next state

// Output logic for f and g
assign f = (state == 3'b001);
assign g = (state == 3'b011 || state == 3'b100);

// Sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= 3'b000; // State A
    end else begin
        state <= nextState;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        3'b000: begin // State A
            if (resetn) begin
                nextState = 3'b001; // State B
            end else begin
                nextState = 3'b000; // Stay in State A
            end
        end
        3'b001: begin // State B
            nextState = 3'b010; // State C
        end
        3'b010: begin // State C
            if (x == 1'b1) begin
                nextState = 3'b011; // State D (first 1 in sequence)
            end else begin
                nextState = 3'b010; // Stay in State C
            end
        end
        3'b011: begin // State D (first 1 in sequence)
            if (x == 1'b0) begin
                nextState = 3'b100; // State E (second 0 in sequence)
            end else begin
                nextState = 3'b010; // Reset sequence
            end
        end
        3'b100: begin // State E (second 0 in sequence)
            if (x == 1'b1) begin
                nextState = 3'b101; // State D (third 1 in sequence)
            end else begin
                nextState = 3'b010; // Reset sequence
            end
        end
        3'b101: begin // State D (third 1 in sequence)
            nextState = 3'b110; // State D
        end
        3'b110: begin // State D
            if (y == 1'b1) begin
                nextState = 3'b111; // State E
            end else if (nextState == 3'b110) begin // Second clock cycle
                nextState = 3'b111; // State E
            end else begin
                nextState = 3'b110; // Stay in State D
            end
        end
        3'b111: begin // State E
            nextState = 3'b111; // Stay in State E
        end
        default: begin
            nextState = 3'b000; // Default to State A
        end
    endcase
end

endmodule