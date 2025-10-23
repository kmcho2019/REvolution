module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] current_state; // Current state of the FSM
reg [1:0] next_state; // Next state of the FSM
reg [2:0] prev_s; // Previous state of the sensors

// Define states
localparam LOW = 2'b00;
localparam LOW_MEDIUM = 2'b01;
localparam MEDIUM_HIGH = 2'b10;
localparam HIGH = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        // Reset to LOW state
        current_state <= LOW;
        prev_s <= 3'b000;
    end else begin
        // Update current state
        current_state <= next_state;
        // Store previous sensor state
        prev_s <= s;
    end
end

always @(*) begin
    // Determine next state
    case (current_state)
        LOW: begin
            if (s[0]) begin
                next_state = LOW_MEDIUM;
            end else begin
                next_state = LOW;
            end
        end
        LOW_MEDIUM: begin
            if (s[1]) begin
                next_state = MEDIUM_HIGH;
            end else if (~s[0]) begin
                next_state = LOW;
            end else begin
                next_state = LOW_MEDIUM;
            end
        end
        MEDIUM_HIGH: begin
            if (s[2]) begin
                next_state = HIGH;
            end else if (~s[1]) begin
                next_state = LOW_MEDIUM;
            end else begin
                next_state = MEDIUM_HIGH;
            end
        end
        HIGH: begin
            next_state = HIGH;
        end
    endcase
end

// Determine output signals based on current state
always @(*) begin
    case (current_state)
        LOW: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
        LOW_MEDIUM: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (s > prev_s) ? 1'b1 : 1'b0;
        end
        MEDIUM_HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (s > prev_s) ? 1'b1 : 1'b0;
        end
        HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
    endcase
end

endmodule