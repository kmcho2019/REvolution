module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the finite state machine
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state, next_state;

// Shift register to store the last four bits of the input data stream
reg [3:0] shift_register;

// Control logic
always_comb begin
    case (state)
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
                next_state = IDLE;
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
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        shift_register <= 4'b0000;
    end else begin
        state <= next_state;
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Comparator logic
wire sequence_match;
assign sequence_match = (shift_register == 4'b1001);

// Output logic
assign sequence_detected = (state == S4) && sequence_match;

endmodule