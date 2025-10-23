module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                    out_bytes[23:16] <= in;
                end
            end
            BYTE1: begin
                state <= BYTE2;
                out_bytes[15:8] <= in;
            end
            BYTE2: begin
                state <= DONE;
                out_bytes[7:0] <= in;
            end
            DONE: begin
                state <= IDLE;
                done <= 1'b1;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!reset && state == DONE) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule