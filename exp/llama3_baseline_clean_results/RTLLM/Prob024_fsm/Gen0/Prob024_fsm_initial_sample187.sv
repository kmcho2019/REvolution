module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define state width
localparam STATE_WIDTH = 3;

// Define states as enumeration
typedef enum logic [STATE_WIDTH-1:0] {
    IDLE = 3'b000,  // Initial state
    RECEIVED_1 = 3'b001,  // Received '1'
    RECEIVED_10 = 3'b010,  // Received '10'
    RECEIVED_100 = 3'b011,  // Received '100'
    RECEIVED_1001 = 3'b100,  // Received '1001'
    RECEIVED_10011 = 3'b101  // Received '10011'
} state_t;

// Current state register
state_t current_state;

// Next state logic and output logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (IN) begin
                    current_state <= RECEIVED_1;
                end else begin
                    current_state <= IDLE;
                end
                MATCH <= 1'b0;
            end
            RECEIVED_1: begin
                if (~IN) begin
                    current_state <= RECEIVED_10;
                end else begin
                    current_state <= RECEIVED_1;
                end
                MATCH <= 1'b0;
            end
            RECEIVED_10: begin
                if (~IN) begin
                    current_state <= RECEIVED_100;
                end else begin
                    current_state <= RECEIVED_1;
                end
                MATCH <= 1'b0;
            end
            RECEIVED_100: begin
                if (IN) begin
                    current_state <= RECEIVED_1001;
                end else begin
                    current_state <= IDLE;
                end
                MATCH <= 1'b0;
            end
            RECEIVED_1001: begin
                if (IN) begin
                    current_state <= RECEIVED_10011;
                end else begin
                    current_state <= IDLE;
                end
                MATCH <= 1'b0;
            end
            RECEIVED_10011: begin
                MATCH <= 1'b1;
                current_state <= IDLE;
            end
            default: begin
                current_state <= IDLE;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule