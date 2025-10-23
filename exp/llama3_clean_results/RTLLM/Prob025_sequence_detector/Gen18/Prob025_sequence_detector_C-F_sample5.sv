module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the states
parameter IDLE = 3'b000;
parameter S1   = 3'b001;
parameter S2   = 3'b010;
parameter S3   = 3'b011;
parameter S4   = 3'b100;

// Current state register
reg [2:0] current_state;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= IDLE;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
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
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                current_state <= IDLE;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule