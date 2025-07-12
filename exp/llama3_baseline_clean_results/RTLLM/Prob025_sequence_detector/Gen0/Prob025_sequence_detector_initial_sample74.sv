module sequence_detector(
    input        clk,
    input        reset_n,
    input        data_in,
    output       sequence_detected
);

// Define states
parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;
parameter S2   = 4'b0010;
parameter S3   = 4'b0100;
parameter S4   = 4'b1000;

reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
reg sequence_detected_reg;

// State machine logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        sequence_detected_reg <= (current_state == S4)? 1'b1 : 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

assign sequence_detected = sequence_detected_reg;

endmodule