module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the states
enum logic [1:0] {
    ABOVE_HIGHEST,
    BETWEEN_HIGHEST_MIDDLE,
    BETWEEN_MIDDLE_LOWEST,
    BELOW_LOWEST
} state, next_state;

// Define the sensor states
reg [2:0] prev_s;

// Sequential logic to update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (s)
        3'b111: next_state = ABOVE_HIGHEST;
        3'b110, 3'b101: next_state = BETWEEN_HIGHEST_MIDDLE;
        3'b011: next_state = BETWEEN_MIDDLE_LOWEST;
        default: next_state = BELOW_LOWEST;
    endcase
end

// Sequential logic to update state
always @(posedge clk) begin
    if (reset) begin
        state <= BELOW_LOWEST;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine output signals
always @(*) begin
    case (state)
        ABOVE_HIGHEST: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        BETWEEN_HIGHEST_MIDDLE: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (s > prev_s);
        end
        BETWEEN_MIDDLE_LOWEST: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (s > prev_s);
        end
        BELOW_LOWEST: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

endmodule