module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State definitions
localparam RESET  = 1'b0;
localparam ACTIVE = 1'b1;

reg state, next_state;
reg [1:0] seq_state;     // Tracks progress in 1-0-1 sequence
reg [1:0] y_timer;       // Counts down from 2 for y monitoring
reg seq_detected;        // Set when 1-0-1 sequence is found
reg y_met;               // Set when y condition is met
reg f_reg, g_reg;

// Continuous assignments for outputs
assign f = f_reg;
assign g = g_reg;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    if (!resetn) begin
        next_state = RESET;
    end else if (state == RESET) begin
        next_state = ACTIVE;
    end
end

// Sequence detection (1-0-1)
always @(posedge clk) begin
    if (!resetn) begin
        seq_state <= 2'b00;
        seq_detected <= 0;
    end else if (state == ACTIVE) begin
        case (seq_state)
            2'b00: seq_state <= x ? 2'b01 : 2'b00;
            2'b01: seq_state <= x ? 2'b01 : 2'b10;
            2'b10: begin
                seq_state <= x ? 2'b00 : 2'b00;
                seq_detected <= x;
            end
            default: seq_state <= 2'b00;
        endcase
    end else begin
        seq_detected <= 0;
    end
end

// Y monitoring logic
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 2'b00;
        y_met <= 0;
    end else if (state == ACTIVE) begin
        if (seq_detected && !y_met) begin
            y_timer <= 2'b10;  // Start 2-cycle timer
            y_met <= y;
        end else if (y_timer != 0 && !y_met) begin
            y_timer <= y_timer - 1;
            y_met <= y_met | y;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        // f output: pulse for one cycle after reset
        f_reg <= (state == RESET && resetn);
        
        // g output logic
        if (seq_detected) begin
            g_reg <= 1;
        end else if (state == ACTIVE && y_timer == 0 && !y_met) begin
            g_reg <= 0;
        end
    end
end

endmodule