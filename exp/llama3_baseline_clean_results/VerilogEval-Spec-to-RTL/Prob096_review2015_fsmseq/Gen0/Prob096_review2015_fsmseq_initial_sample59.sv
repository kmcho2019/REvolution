module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
enum logic [1:0] {
    idle = 2'b00,
    saw_1 = 2'b01,
    saw_11 = 2'b10,
    saw_110 = 2'b11,
    saw_1101 = 2'b00 // reuse idle state
} state, next_state;

always @(*) begin
    case (state)
        idle: begin
            if (data == 1'b1) begin
                next_state = saw_1;
            end else begin
                next_state = idle;
            end
        end
        saw_1: begin
            if (data == 1'b1) begin
                next_state = saw_11;
            end else if (data == 1'b0) begin
                next_state = idle;
            end
        end
        saw_11: begin
            if (data == 1'b0) begin
                next_state = saw_110;
            end else if (data == 1'b1) begin
                next_state = saw_11;
            end
        end
        saw_110: begin
            if (data == 1'b1) begin
                next_state = saw_1101;
            end else begin
                next_state = idle;
            end
        end
        saw_1101: begin
            next_state = saw_1101; // stay in saw_1101 state
        end
        default: next_state = idle;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == saw_1101) begin
            start_shifting <= 1'b1;
        end
    end
end

endmodule