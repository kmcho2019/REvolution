module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state, nextState;
parameter IDLE = 2'b00, SEEN1 = 2'b01, SEEN10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (x) begin
                nextState = SEEN1;
            end else begin
                nextState = IDLE;
            end
        end
        SEEN1: begin
            if (x) begin
                nextState = SEEN1;
            end else begin
                nextState = SEEN10;
            end
        end
        SEEN10: begin
            if (x) begin
                nextState = SEEN1; // Because we allow overlapping sequences, seeing '1' here means starting over from SEEN1
            end else begin
                nextState = SEEN10; // Stay in SEEN10 if '0' is seen again, allowing overlap
            end
        end
    endcase
end

always @(*) begin
    case(state)
        IDLE: z = 1'b0;
        SEEN1: z = 1'b0;
        SEEN10: z = x; // Assert z when in SEEN10 and x is '1'
    endcase
end

endmodule