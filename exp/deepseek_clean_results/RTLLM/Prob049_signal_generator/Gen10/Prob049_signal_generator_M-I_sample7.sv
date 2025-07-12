module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Gray-coded state (0=inc, 1=dec) to minimize switching
reg state;  
wire state_gray = state ^ (state >> 1);

// Pre-compute next wave value
reg [4:0] next_wave;
wire at_max = &wave;    // wave == 31
wire at_min = ~|wave;   // wave == 0

// Clock gating control
wire clk_enable = ~((state == 0 && at_max) || (state == 1 && at_min));

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else if (clk_enable) begin
        wave <= next_wave;
    end
end

// Combinational next state and wave logic
always @(*) begin
    if (state == 0) begin
        next_wave = wave + 1'b1;
        if (at_max) begin
            next_wave = wave - 1'b1; // Prepare for decrement
        end
    end else begin
        next_wave = wave - 1'b1;
        if (at_min) begin
            next_wave = wave + 1'b1; // Prepare for increment
        end
    end
end

// State transition (registered to break critical path)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 1'b0;
    end else begin
        if (state == 0 && at_max) begin
            state <= 1'b1;
        end else if (state == 1 && at_min) begin
            state <= 1'b0;
        end
    end
end

endmodule