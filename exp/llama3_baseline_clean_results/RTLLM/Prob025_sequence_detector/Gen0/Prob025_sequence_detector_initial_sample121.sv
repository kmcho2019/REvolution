module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output sequence_detected
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Output logic
assign sequence_detected = (state == S4);

// State machine
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule