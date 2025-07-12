module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Binary encoded states
    reg [1:0] state;
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    // Shift register for byte collection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        out_bytes <= {in, 16'b0};
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    out_bytes <= {out_bytes[23:16], in, 8'b0};
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes <= {out_bytes[23:8], in};
                    state <= IDLE;
                end
            endcase
        end
    end

    // Combinational done signal
    assign done = (state == BYTE2);

endmodule