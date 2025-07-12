module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the desired sequence as a parameter
parameter DESIRED_SEQUENCE = 4'b1001;

// Define the states
enum logic [2:0] {IDLE, S1, S2, S3, S4} current_state, next_state;

// State register
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next state
always_comb begin
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
            end else begin
                next_state = S3;
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
        default: next_state = IDLE;
    endcase
end

// Output logic to detect the sequence
assign sequence_detected = (current_state == S4);

endmodule