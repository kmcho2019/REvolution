module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // State machine with 6 states (3 bits)

// Define states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam MATCH_STATE = 3'b101;

// State machine logic with reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE; // Reset state machine
        MATCH <= 1'b0; // Reset MATCH signal
    end else begin
        case (state)
            IDLE: begin
                if (IN) begin
                    state <= S1;
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                if (IN) begin
                    state <= MATCH_STATE;
                end else begin
                    state <= IDLE;
                end
            end
            MATCH_STATE: begin
                MATCH <= 1'b1; // Set MATCH signal when in MATCH state
                state <= IDLE; // Transition back to IDLE after setting MATCH
            end
            default: state <= IDLE;
        endcase
    end
end

// Continuous assignment for MATCH signal based on state
assign MATCH = (state == MATCH_STATE) ? 1'b1 : 1'b0;

endmodule