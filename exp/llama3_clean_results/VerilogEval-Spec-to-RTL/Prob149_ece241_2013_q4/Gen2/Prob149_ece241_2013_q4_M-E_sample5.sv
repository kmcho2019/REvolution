module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] current_state;
reg [1:0] next_state;
reg [1:0] prev_state;

// Define the states
localparam ABOVE_S2 = 2'b00;
localparam BETWEEN_S2_S1 = 2'b01;
localparam BETWEEN_S1_S0 = 2'b10;
localparam BELOW_S0 = 2'b11;

// Initialize the state
initial current_state = ABOVE_S2;
initial prev_state = ABOVE_S2;

// FSM logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        current_state <= BELOW_S0;
        prev_state <= BELOW_S0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update the state
        current_state <= next_state;
        prev_state <= current_state;
        
        // Update the output signals
        case (current_state)
            ABOVE_S2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state == BELOW_S0 || prev_state == BETWEEN_S1_S0) ? 1'b1 : 1'b0;
            end
            BETWEEN_S1_S0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == BELOW_S0) ? 1'b1 : 1'b0;
            end
            BELOW_S0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

// Determine the next state
always @(*) begin
    case (s)
        3'b111: next_state = ABOVE_S2;
        3'b011: next_state = BETWEEN_S2_S1;
        3'b001: next_state = BETWEEN_S1_S0;
        default: next_state = BELOW_S0;
    endcase
end

endmodule