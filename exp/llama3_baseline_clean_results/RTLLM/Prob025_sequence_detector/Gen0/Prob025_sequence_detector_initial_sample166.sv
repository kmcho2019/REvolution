module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
localparam IDLE = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;

reg [3:0] current_state;
reg [3:0] next_state;

// Initialize state machine
initial begin
    current_state = IDLE;
    sequence_detected = 1'b0;
end

// State machine logic
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
                next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            if (data_in == 1'b1) begin
                sequence_detected = 1'b1;
                next_state = S4;
            end
            else
                next_state = IDLE;
        end
        default:
            next_state = IDLE;
    endcase
end

// State machine update
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else
        current_state <= next_state;
end

endmodule