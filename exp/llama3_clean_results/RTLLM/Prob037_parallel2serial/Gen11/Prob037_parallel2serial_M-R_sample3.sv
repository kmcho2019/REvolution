module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

enum logic [1:0] {IDLE, CONVERTING, DONE} state, next_state;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (d != 4'b0000) begin
                next_state = CONVERTING;
            end else begin
                next_state = IDLE;
            end
        end
        CONVERTING: begin
            if (d[3] == 1'b1) begin
                next_state = CONVERTING;
                dout = d[3];
                valid_out = 1'b1;
                d = d << 1;
            end else if (d[2] == 1'b1) begin
                next_state = CONVERTING;
                dout = d[2];
                valid_out = 1'b1;
                d = d << 1;
            end else if (d[1] == 1'b1) begin
                next_state = CONVERTING;
                dout = d[1];
                valid_out = 1'b1;
                d = d << 1;
            end else begin
                next_state = DONE;
                dout = d[0];
                valid_out = 1'b1;
            end
        end
        DONE: begin
            next_state = IDLE;
            valid_out = 1'b0;
        end
        default: next_state = IDLE;
    endcase
end

endmodule