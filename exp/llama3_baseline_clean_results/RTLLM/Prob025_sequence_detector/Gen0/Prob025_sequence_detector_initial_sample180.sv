module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;

// Current state register
reg [3:0] current_state;
reg [3:0] next_state;

// Initialize the sequence_detected output
initial sequence_detected = 0;

// State machine transitions
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
                next_state = S2;
            end else if (data_in == 1'b1) begin
                next_state = S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else if (data_in == 1'b0) begin
                next_state = S2;
            end else if (data_in == 1'b0) begin
                next_state = S2;
            end else if (data_in == 1'b1) begin
                next_state = S3;
            end
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S3;
            end
        end
        S4: begin
            next_state = IDLE;
            sequence_detected = 1'b1;
        end
        default: next_state = IDLE;
    endcase
end

// Update current state on clock edge
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Output sequence_detected
always @(current_state) begin
    if (current_state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule