module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                end
            end
            BYTE1: state <= BYTE2;
            BYTE2: state <= BYTE3;
            BYTE3: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: done <= 1'b0;
            BYTE1: done <= 1'b0;
            BYTE2: done <= 1'b0;
            BYTE3: done <= 1'b1;
        endcase
    end
end

endmodule