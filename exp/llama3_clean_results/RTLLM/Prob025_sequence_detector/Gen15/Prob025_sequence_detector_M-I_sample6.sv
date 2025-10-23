module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] state; // One-hot encoding for states
reg [3:0] next_state;

reg data_in_sync; // Synchronized input signal

localparam IDLE = 4'b0001;
localparam S1 = 4'b0010;
localparam S2 = 4'b0100;
localparam S3 = 4'b1000;

// Synchronize input signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_sync <= 1'b0;
    end else begin
        data_in_sync <= data_in;
    end
end

// Next State Logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in_sync == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in_sync == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in_sync == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in_sync == 1'b1) begin
                next_state = IDLE; // Sequence detected, return to IDLE
                sequence_detected <= 1'b1;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// State Update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        if (state == IDLE && next_state == IDLE) begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule