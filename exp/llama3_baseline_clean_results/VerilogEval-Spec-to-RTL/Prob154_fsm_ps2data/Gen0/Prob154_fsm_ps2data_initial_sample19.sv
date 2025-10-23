module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam BYTE_1 = 2'b01;
localparam BYTE_2 = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    state <= BYTE_1;
                    out_bytes[23:16] <= in;
                end
            end
            BYTE_1: begin
                state <= BYTE_2;
                out_bytes[15:8] <= in;
            end
            BYTE_2: begin
                state <= IDLE;
                out_bytes[7:0] <= in;
                done <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state != BYTE_2) begin
            done <= 0;
        end
    end else begin
        done <= 0;
    end
end

endmodule