module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, // Initial state
             DETECT_1 = 2'b01, // Detected the first '1'
             DETECT_110 = 2'b10, // Detected '110'
             DETECTED = 2'b11; // Sequence fully detected

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(data) begin
                    state <= DETECT_1;
                end else begin
                    state <= IDLE;
                end
            end
            DETECT_1: begin
                if(data) begin
                    state <= DETECT_110;
                end else begin
                    state <= IDLE;
                end
            end
            DETECT_110: begin
                if(!data) begin
                    state <= DETECTED;
                end else begin
                    state <= DETECT_1;
                end
            end
            DETECTED: begin
                state <= DETECTED; // Stay in detected state until reset
            end
            default: state <= IDLE;
        endcase
        
        // Set start_shifting high if sequence is detected
        if(state == DETECTED) begin
            start_shifting <= 1'b1;
        end else begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule