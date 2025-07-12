module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg [1:0] state, next_state;
reg a_prev;

localparam IDLE = 2'b00;
localparam EDGE_DETECTED = 2'b01;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        a_prev <= 1'b0;
    end else begin
        state <= next_state;
        a_prev <= a;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            rise = 1'b0;
            down = 1'b0;
            if (a_prev != a) begin
                next_state = EDGE_DETECTED;
            end else begin
                next_state = IDLE;
            end
        end
        EDGE_DETECTED: begin
            rise = (a_prev == 1'b0) && (a == 1'b1);
            down = (a_prev == 1'b1) && (a == 1'b0);
            next_state = IDLE;
        end
        default: begin
            rise = 1'b0;
            down = 1'b0;
            next_state = IDLE;
        end
    endcase
end

endmodule