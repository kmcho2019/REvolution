module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
localparam IDLE = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0100;
localparam S4 = 4'b1000;

reg [3:0] current_state;

// Initialize the state machine
initial begin
    current_state = IDLE;
    sequence_detected = 1'b0;
end

// State machine transitions
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                sequence_detected <= 1'b1;
                current_state <= IDLE;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Reset sequence_detected after one clock cycle
always @(posedge clk) begin
    if (current_state != S4) begin
        sequence_detected <= 1'b0;
    end
end

endmodule