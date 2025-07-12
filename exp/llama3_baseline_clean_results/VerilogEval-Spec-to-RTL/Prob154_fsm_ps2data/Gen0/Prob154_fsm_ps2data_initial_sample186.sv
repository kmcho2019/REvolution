module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;

    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    if(in[3]) begin
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
                    state <= BYTE3;
                end
                BYTE3: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if(state != BYTE3) begin
            done <= 1'b0;
        end
    end

endmodule