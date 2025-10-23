module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state
reg [1:0] x_seq; // x sequence counter
reg [1:0] y_timer; // y timer

// Initialize the outputs
assign f = (state == 3'b001); // Set f to 1 in state B
assign g = (state >= 3'b100); // Set g to 1 in states D, E, F

// x sequence detector
always @(posedge clk) begin
    if (!resetn) begin
        x_seq <= 0;
    end else if (state == 3'b010) begin
        if (x) begin
            x_seq <= x_seq + 1;
        end else begin
            x_seq <= 0;
        end
    end else begin
        x_seq <= 0;
    end
end

// y timer
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 0;
    end else if (state == 3'b100) begin
        if (y) begin
            y_timer <= 0;
        end else begin
            y_timer <= y_timer + 1;
        end
    end else begin
        y_timer <= 0;
    end
end

// State machine
always @(posedge clk) begin
    if (!resetn) begin
        state <= 3'b000; // Reset state
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        3'b000: // State A (reset state)
            if (resetn) begin
                nextState = 3'b001; // Go to state B
            end else begin
                nextState = 3'b000; // Stay in state A
            end
        3'b001: // State B (set f to 1)
            nextState = 3'b010; // Go to state C
        3'b010: // State C (monitor x)
            if (x_seq == 2'b11) begin
                nextState = 3'b100; // Go to state D
            end else begin
                nextState = 3'b010; // Stay in state C
            end
        3'b100: // State D (set g to 1)
            if (y_timer < 2) begin
                nextState = 3'b101; // Go to state E
            end else begin
                nextState = 3'b110; // Go to state G
            end
        3'b101: // State E (monitor y)
            if (y) begin
                nextState = 3'b111; // Go to state F
            end else if (y_timer < 2) begin
                nextState = 3'b101; // Stay in state E
            end else begin
                nextState = 3'b110; // Go to state G
            end
        3'b110, 3'b111: // States G and F (final states)
            nextState = state; // Stay in the same state
    endcase
end

endmodule