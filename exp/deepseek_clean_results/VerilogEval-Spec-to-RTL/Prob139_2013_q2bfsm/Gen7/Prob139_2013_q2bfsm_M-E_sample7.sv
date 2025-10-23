module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
localparam RESET  = 2'b00;
localparam ACTIVE = 2'b01;
localparam FINAL  = 2'b10;

reg [1:0] state, next_state;
reg [2:0] x_shift;        // Shift register for x sequence detection
reg y_timer;              // 1-bit timer for y monitoring (0=cycle1, 1=cycle2)
reg sequence_detected;    // Flag when 1-0-1 sequence is found
reg y_satisfied;          // Flag when y condition is met

// Shift register and sequence detection
always @(posedge clk) begin
    if (!resetn) begin
        x_shift <= 3'b000;
        sequence_detected <= 0;
    end
    else if (state == ACTIVE) begin
        x_shift <= {x_shift[1:0], x};
        sequence_detected <= (x_shift == 3'b101);
    end
    else begin
        sequence_detected <= 0;
    end
end

// Y monitoring timer and flag
always @(posedge clk) begin
    if (!resetn) begin
        y_timer <= 0;
        y_satisfied <= 0;
    end
    else if (state == ACTIVE && sequence_detected) begin
        y_timer <= 0;  // Start timer
        y_satisfied <= y;
    end
    else if (state == FINAL && !y_satisfied) begin
        y_timer <= y_timer + 1;
        y_satisfied <= y_satisfied | y;
    end
end

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
    end
    else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        RESET: next_state = resetn ? ACTIVE : RESET;
        ACTIVE: next_state = sequence_detected ? FINAL : ACTIVE;
        FINAL: next_state = FINAL;  // Stay in final state until reset
        default: next_state = RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
    end
    else begin
        // f output: pulse for one cycle after reset
        f <= (state == RESET && resetn);
        
        // g output logic
        if (state == ACTIVE && sequence_detected) begin
            g <= 1;  // Set g when sequence detected
        end
        else if (state == FINAL && !y_satisfied && y_timer) begin
            g <= 0;  // Clear g after timeout
        end
    end
end

endmodule