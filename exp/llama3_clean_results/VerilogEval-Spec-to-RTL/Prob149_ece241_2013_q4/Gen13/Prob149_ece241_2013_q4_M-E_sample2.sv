module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state; // Register to store current state
reg [1:0] prev_state; // Register to store previous state

// Define states
localparam ABOVE_HIGH = 2'b00;
localparam BETWEEN_HIGH_AND_MIDDLE = 2'b01;
localparam BETWEEN_MIDDLE_AND_LOW = 2'b10;
localparam BELOW_LOW = 2'b11;

// Sequential logic to update state
always @(posedge clk) begin
    if (reset) begin
        // Reset to BELOW_LOW state
        state <= BELOW_LOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Store previous state
        prev_state <= state;

        // Determine next state based on current state and input signals
        case (state)
            ABOVE_HIGH: begin
                if (~s[2] && s[1]) begin
                    state <= BETWEEN_HIGH_AND_MIDDLE;
                end
            end
            BETWEEN_HIGH_AND_MIDDLE: begin
                if (~s[1] && s[0]) begin
                    state <= BETWEEN_MIDDLE_AND_LOW;
                end else if (~s[1] && ~s[0]) begin
                    state <= BELOW_LOW;
                end else if (s[2]) begin
                    state <= ABOVE_HIGH;
                end
            end
            BETWEEN_MIDDLE_AND_LOW: begin
                if (~s[0]) begin
                    state <= BELOW_LOW;
                end else if (s[1]) begin
                    state <= BETWEEN_HIGH_AND_MIDDLE;
                end
            end
            BELOW_LOW: begin
                if (s[0]) begin
                    state <= BETWEEN_MIDDLE_AND_LOW;
                end else if (s[1]) begin
                    state <= BETWEEN_HIGH_AND_MIDDLE;
                end else if (s[2]) begin
                    state <= ABOVE_HIGH;
                end
            end
        endcase

        // Determine output signals based on current state
        case (state)
            ABOVE_HIGH: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_HIGH_AND_MIDDLE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (state > prev_state);
            end
            BETWEEN_MIDDLE_AND_LOW: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (state > prev_state);
            end
            BELOW_LOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (state > prev_state);
            end
        endcase
    end
end

endmodule