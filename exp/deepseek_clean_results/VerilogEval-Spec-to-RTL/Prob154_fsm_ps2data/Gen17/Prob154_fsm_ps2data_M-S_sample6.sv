module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state;
    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end

                BYTE2: begin
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule