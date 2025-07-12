module TopModule (
    input           clk,
    input           aresetn,
    input           x,
    output reg      z
);

reg [1:0] state;

localparam IDLE        = 2'b00;
localparam ONE_DETECTED = 2'b01;
localparam ZERO_DETECTED_AFTER_ONE = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
        z <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state <= ONE_DETECTED;
                end else begin
                    state <= IDLE;
                end
                z <= 1'b0;
            end
            ONE_DETECTED: begin
                if (x == 1'b0) begin
                    state <= ZERO_DETECTED_AFTER_ONE;
                end else begin
                    state <= ONE_DETECTED;
                end
                z <= 1'b0;
            end
            ZERO_DETECTED_AFTER_ONE: begin
                if (x == 1'b1) begin
                    state <= IDLE;
                    z <= 1'b1;
                end else begin
                    state <= ZERO_DETECTED_AFTER_ONE;
                end
            end
        endcase
    end
end

endmodule