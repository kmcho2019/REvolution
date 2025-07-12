module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam RECEIVE_BYTE1 = 2'b01;
localparam RECEIVE_BYTE2 = 2'b10;
localparam RECEIVE_BYTE3 = 2'b11;

reg [7:0] byte1, byte2, byte3;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(in[3]) begin
                    state <= RECEIVE_BYTE1;
                    byte1 <= in;
                end else begin
                    state <= IDLE;
                end
                done <= 0;
            end
            RECEIVE_BYTE1: begin
                state <= RECEIVE_BYTE2;
                byte2 <= in;
            end
            RECEIVE_BYTE2: begin
                state <= RECEIVE_BYTE3;
                byte3 <= in;
            end
            RECEIVE_BYTE3: begin
                state <= IDLE;
                out_bytes <= {byte1, byte2, byte3};
                done <= 1;
            end
        endcase
    end
end

endmodule