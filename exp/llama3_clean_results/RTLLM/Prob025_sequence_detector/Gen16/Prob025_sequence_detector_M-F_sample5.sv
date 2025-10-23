module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state; // State machine states
reg [1:0] next_state;

localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// Next State Logic
always @(*) begin
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
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// State Update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule