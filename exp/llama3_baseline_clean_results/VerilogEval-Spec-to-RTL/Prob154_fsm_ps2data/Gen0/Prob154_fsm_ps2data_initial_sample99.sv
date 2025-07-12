module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;
    reg [1:0] state;
    reg done_reg;

    parameter IDLE = 2'b00;
    parameter BYTE1 = 2'b01;
    parameter BYTE2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    if(in[3] == 1'b1) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    done_reg <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

    assign out_bytes = {byte1, byte2, byte3};
    assign done = done_reg;

endmodule