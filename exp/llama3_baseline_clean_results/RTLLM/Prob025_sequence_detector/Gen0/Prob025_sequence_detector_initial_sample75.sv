module sequence_detector(
    input        clk, 
    input        reset_n, 
    input        data_in, 
    output reg   sequence_detected
);

// Define states
localparam IDLE    = 4'b0000;
localparam S1       = 4'b0001;
localparam S2       = 4'b0010;
localparam S3       = 4'b0100;
localparam S4       = 4'b1000;

reg [3:0] current_state;
reg [3:0] next_state;

// Initialize state machine
initial current_state = IDLE;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: 
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        S1: 
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        S2: 
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        S3: 
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        S4: 
            if (data_in == 1'b1) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        default: 
            next_state = IDLE;
    endcase
end

// Update current state
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule