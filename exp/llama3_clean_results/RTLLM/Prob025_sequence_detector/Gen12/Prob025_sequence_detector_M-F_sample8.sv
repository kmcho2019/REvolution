module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state;
reg [2:0] next_state;

reg data_in_sync; // Synchronized input signal

localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

// Synchronize input signal
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        data_in_sync <= 1'b0;
    end else begin
        data_in_sync <= data_in;
    end
end

// Output Generation
assign sequence_detected = (state == S4);

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
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
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
    end else begin
        state <= next_state;
    end
end

endmodule