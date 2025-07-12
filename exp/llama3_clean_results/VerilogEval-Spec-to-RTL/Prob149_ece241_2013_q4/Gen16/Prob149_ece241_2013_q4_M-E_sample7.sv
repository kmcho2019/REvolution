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
localparam BETWEEN_HIGH_LOW = 2'b01;
localparam BETWEEN_LOW_LOWEST = 2'b10;
localparam BELOW_LOWEST = 2'b11;

// Sequential logic to update state and previous state
always @(posedge clk) begin
    if (reset) begin
        state <= BELOW_LOWEST;
        prev_state <= BELOW_LOWEST;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        case (s)
            3'b111, 3'b110, 3'b101: state <= ABOVE_HIGH;
            3'b011: state <= BETWEEN_HIGH_LOW;
            3'b001: state <= BETWEEN_LOW_LOWEST;
            3'b000: state <= BELOW_LOWEST;
            default: state <= state;
        endcase
    end
end

// Combinational logic to determine output signals
always @(posedge clk) begin
    case (state)
        ABOVE_HIGH: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        BETWEEN_HIGH_LOW: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (prev_state == BELOW_LOWEST || prev_state == BETWEEN_LOW_LOWEST);
        end
        BETWEEN_LOW_LOWEST: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (prev_state == BELOW_LOWEST);
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