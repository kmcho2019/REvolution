module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // state register to track current state

// Define states
localparam IDLE = 3'b000;
localparam GOT_1 = 3'b001;
localparam GOT_11 = 3'b010;
localparam GOT_110 = 3'b011;
localparam GOT_1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin // reset is active high
        state <= IDLE; // reset state to IDLE
        start_shifting <= 0; // clear start_shifting
    end else begin
        case (state)
            IDLE: begin
                if (data) begin // first '1'
                    state <= GOT_1;
                end
            end
            GOT_1: begin
                if (data) begin // second '1'
                    state <= GOT_11;
                end else begin
                    state <= IDLE; // not '11', restart
                end
            end
            GOT_11: begin
                if (~data) begin // '0' after '11'
                    state <= GOT_110;
                end else begin
                    state <= GOT_11; // continue '11' sequence
                end
            end
            GOT_110: begin
                if (data) begin // '1' after '110'
                    state <= GOT_1101;
                    start_shifting <= 1; // set start_shifting
                end else begin
                    state <= IDLE; // sequence not found, restart
                end
            end
            GOT_1101: begin
                // Stay in this state, start_shifting remains 1
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule