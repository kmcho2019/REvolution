module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // FSM state variable
reg [1:0] prev_state; // Previous FSM state
reg [2:0] prev_s; // Previous sensor state

// Define the FSM states
localparam ABOVE_HIGH = 2'b00;
localparam BETWEEN_HIGH_MIDDLE = 2'b01;
localparam BETWEEN_MIDDLE_LOW = 2'b10;
localparam BELOW_LOW = 2'b11;

// Sequential logic to update FSM state and previous sensor state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= BELOW_LOW;
        prev_state <= BELOW_LOW;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous sensor state
        prev_s <= s;
        
        // Update previous FSM state
        prev_state <= state;
        
        // Update FSM state based on input sensor signals
        if (s[2] == 1'b1) begin
            state <= ABOVE_HIGH;
        end else if (s[1] == 1'b1) begin
            state <= BETWEEN_HIGH_MIDDLE;
        end else if (s[0] == 1'b1) begin
            state <= BETWEEN_MIDDLE_LOW;
        end else begin
            state <= BELOW_LOW;
        end
    end
end

// Combinational logic to determine output signals (fr2, fr1, fr0) and dfr
always @(*) begin
    case (state)
        ABOVE_HIGH: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
        BETWEEN_HIGH_MIDDLE: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (prev_state == BELOW_LOW || prev_state == BETWEEN_MIDDLE_LOW) && (state == BETWEEN_HIGH_MIDDLE);
        end
        BETWEEN_MIDDLE_LOW: begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_state == BELOW_LOW) && (state == BETWEEN_MIDDLE_LOW);
        end
        BELOW_LOW: begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_state != BELOW_LOW) && (state == BELOW_LOW);
        end
    endcase
end

endmodule