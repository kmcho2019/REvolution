module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;

// Define states
parameter RESET = 2'b00;
parameter ONE_DETECTED = 2'b01;
parameter ZERO_DETECTED_AFTER_ONE = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        RESET: begin
            if (x) begin
                next_state = ONE_DETECTED;
            end else begin
                next_state = RESET;
            end
            z = 1'b0;
        end
        ONE_DETECTED: begin
            if (x) begin
                next_state = ONE_DETECTED;
            end else begin
                next_state = ZERO_DETECTED_AFTER_ONE;
            end
            z = 1'b0;
        end
        ZERO_DETECTED_AFTER_ONE: begin
            if (x) begin
                next_state = ONE_DETECTED;
                z = 1'b1;
            end else begin
                next_state = RESET;
            end
            z = (x) ? 1'b1 : 1'b0;
        end
    endcase
end

endmodule