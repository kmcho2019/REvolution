module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states
parameter IDLE = 2'b00;
parameter S1   = 2'b01;
parameter S2   = 2'b10;
parameter S3   = 2'b11;

// Current state register
reg [1:0] current_state;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in) begin
                    current_state <= S1;
                end
            end
            S1: begin
                if (~data_in) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (~data_in) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in) begin
                    current_state <= IDLE;
                end else begin
                    current_state <= IDLE;
                end
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Output logic
assign sequence_detected = (current_state == S3);

endmodule