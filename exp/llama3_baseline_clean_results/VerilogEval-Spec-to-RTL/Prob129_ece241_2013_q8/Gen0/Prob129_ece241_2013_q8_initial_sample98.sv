module TopModule (
    input           clk,
    input           aresetn,
    input           x,
    output reg      z
);

reg [1:0] state, next_state;

localparam IDLE = 2'b00;
localparam SEEN1 = 2'b01;
localparam SEEN10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEEN1;
            end else begin
                next_state = IDLE;
            end
            z = 1'b0;
        end
        SEEN1: begin
            if (~x) begin
                next_state = SEEN10;
            end else if (x) begin
                next_state = SEEN1;
            end
            z = 1'b0;
        end
        SEEN10: begin
            if (x) begin
                next_state = SEEN1;
                z = 1'b1;
            end else begin
                next_state = SEEN10;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule