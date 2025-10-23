module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [1:0] nextState; // 2-bit next state register

// State definitions
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE_STATE = 2'b11;

reg done_reg; // register to hold the done signal

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        done_reg <= 1'b0; // default done_reg to 0
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    nextState <= BYTE1;
                end else begin
                    nextState <= IDLE;
                end
            end
            BYTE1: begin
                nextState <= BYTE2;
            end
            BYTE2: begin
                nextState <= DONE_STATE;
            end
            DONE_STATE: begin
                done_reg <= 1'b1; // signal done in the next cycle
                nextState <= IDLE;
            end
        endcase
    end
end

assign done = done_reg;

endmodule