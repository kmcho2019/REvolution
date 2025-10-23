// sequence_detector.v
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
parameter IDLE = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;

// Declare the current and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Assign the initial state
initial current_state = IDLE;

// Reset the sequence_detected output
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        sequence_detected <= 1'b0;
    end else if (current_state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

// Sequence detection logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule