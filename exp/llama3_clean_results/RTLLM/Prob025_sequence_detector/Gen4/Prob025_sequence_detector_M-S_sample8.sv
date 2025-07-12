module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the states
localparam IDLE    = 4'b0000;
localparam S1      = 4'b1000;
localparam S2      = 4'b1001;
localparam S3      = 4'b10010;
localparam S4      = 4'b10010;

// Declare the current state
reg [3:0] current_state;

// Assign the initial state
initial current_state = IDLE;

// State transition logic
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
                sequence_detected <= 1'b0;
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
                sequence_detected <= 1'b0;
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= IDLE;
                    sequence_detected <= 1'b1;
                end else begin
                    current_state <= IDLE;
                    sequence_detected <= 1'b0;
                end
            end
            default: begin
                current_state <= IDLE;
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule