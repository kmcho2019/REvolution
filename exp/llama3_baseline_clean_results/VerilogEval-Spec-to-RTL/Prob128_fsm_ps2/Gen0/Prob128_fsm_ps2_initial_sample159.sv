module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                state <= BYTE2;
            end
            BYTE2: begin
                state <= IDLE;
                done <= 1'b1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (state == IDLE || state == BYTE1) begin
        done <= 1'b0;
    end
end

endmodule