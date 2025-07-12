module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence using binary encoding
enum logic [1:0] {
    IDLE = 2'b00,
    STATE_1 = 2'b01,
    STATE_11 = 2'b10,
    STATE_110 = 2'b11
} state;

// Initialize the FSM to the IDLE state
initial state = IDLE;

reg sequence_detected;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        sequence_detected <= 0;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data == 1'b1) begin
                    state <= STATE_1;
                end else begin
                    state <= IDLE;
                end
            end
            STATE_1: begin
                if(data == 1'b1) begin
                    state <= STATE_11;
                end else begin
                    state <= IDLE;
                end
            end
            STATE_11: begin
                if(data == 1'b0) begin
                    state <= STATE_110;
                end else begin
                    state <= STATE_1;
                end
            end
            STATE_110: begin
                if(data == 1'b1) begin
                    state <= STATE_110;
                    sequence_detected <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
        if(sequence_detected) begin
            start_shifting <= 1;
        end else if(reset) begin
            start_shifting <= 0;
        end
    end
end

endmodule