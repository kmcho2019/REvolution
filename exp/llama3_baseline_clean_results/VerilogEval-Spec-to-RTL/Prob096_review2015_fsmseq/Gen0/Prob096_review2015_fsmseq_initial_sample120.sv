module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
localparam IDLE = 4'd0;
localparam SEEN_1 = 4'd1;
localparam SEEN_11 = 4'd2;
localparam SEEN_110 = 4'd3;
localparam FOUND = 4'd4;

// Current state register
reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (data == 1) begin
                next_state = SEEN_11;
            end else if (data == 0) begin
                next_state = IDLE;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_11: begin
            if (data == 0) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data == 1) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == FOUND) begin
            start_shifting <= 1;
        end
    end
end

endmodule