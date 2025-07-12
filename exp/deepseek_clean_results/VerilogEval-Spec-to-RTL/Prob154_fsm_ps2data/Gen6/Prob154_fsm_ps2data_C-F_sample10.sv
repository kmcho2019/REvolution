module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // States
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] out_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        out_reg[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    out_reg[15:8] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_reg[7:0] <= in;
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Registered output to prevent glitches
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'b0;
        end else if (done) begin
            out_bytes <= out_reg;
        end
    end

endmodule