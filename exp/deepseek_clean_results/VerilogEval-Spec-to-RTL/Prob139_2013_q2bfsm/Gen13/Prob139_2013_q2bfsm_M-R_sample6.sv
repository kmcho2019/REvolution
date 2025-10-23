module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State parameters
localparam RESET   = 2'b00;
localparam INIT    = 2'b01;
localparam MONITOR = 2'b10;
localparam FINAL   = 2'b11;

reg [1:0] current_state, next_state;

// Pattern detection shift register
reg [2:0] x_history;
always @(posedge clk) begin
    if (!resetn) begin
        x_history <= 3'b0;
    end else begin
        x_history <= {x_history[1:0], x};
    end
end
wire pattern_match = (x_history == 3'b101);

// Timeout counter
reg [1:0] timeout_counter;
always @(posedge clk) begin
    if (!resetn) begin
        timeout_counter <= 2'b0;
    end else if (current_state == MONITOR && pattern_match) begin
        timeout_counter <= timeout_counter + 1;
    end else begin
        timeout_counter <= 2'b0;
    end
end

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET:   next_state = resetn ? INIT : RESET;
        INIT:    next_state = MONITOR;
        MONITOR: begin
            if (pattern_match) begin
                if (y) begin
                    next_state = FINAL;
                end else if (timeout_counter == 2'b10) begin
                    next_state = FINAL;
                end else begin
                    next_state = MONITOR;
                end
            end else begin
                next_state = MONITOR;
            end
        end
        FINAL:   next_state = FINAL;
        default: next_state = RESET;
    endcase
end

// Output logic
reg f_reg, g_reg;
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        f_reg <= (current_state == RESET && next_state == INIT);
        
        if (current_state == FINAL) begin
            g_reg <= (timeout_counter != 2'b10);
        end else begin
            g_reg <= 1'b0;
        end
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule