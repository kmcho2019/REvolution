module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        state <= BYTE2;
                    end
                end
                
                BYTE2: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    out_bytes[7:0] <= in;
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule