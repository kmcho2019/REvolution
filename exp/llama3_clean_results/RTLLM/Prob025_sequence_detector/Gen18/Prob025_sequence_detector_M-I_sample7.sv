module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states
parameter IDLE = 4'b0001;
parameter S1 = 4'b0010;
parameter S2 = 4'b0100;
parameter S3 = 4'b1000;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Output logic
assign sequence_detected = (current_state == S3 && data_in == 1'b1);

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state <= IDLE;
            end else if (data_in == 1'b0) begin
                next_state <= S1;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else begin
                next_state <= IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else if (data_in == 1'b1) begin
                next_state <= S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state <= IDLE;
            end else begin
                next_state <= IDLE;
            end
        end
        default: next_state <= IDLE;
    endcase
end

endmodule