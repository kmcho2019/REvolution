module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;

// Internal state register
reg [2:0] state;
reg [2:0] next_state;

// Initialize state to IDLE
initial state = IDLE;

// Sequence detection logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
    endcase
end

// Update state on clock edge
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 0;
    end else begin
        state <= next_state;
        if (state == S4) begin
            sequence_detected <= 1;
        end else begin
            sequence_detected <= 0;
        end
    end
end

endmodule