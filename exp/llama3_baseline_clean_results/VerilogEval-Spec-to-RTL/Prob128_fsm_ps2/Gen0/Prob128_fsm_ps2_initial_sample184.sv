module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2 bits for 4 states
reg [1:0] nextState;

// State definitions
parameter IDLE = 2'd0;
parameter BYTE1 = 2'd1;
parameter BYTE2 = 2'd2;
parameter DONE = 2'd3;

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            nextState = BYTE2;
        end
        BYTE2: begin
            nextState = DONE;
        end
        DONE: begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

assign done = (state == DONE);

endmodule