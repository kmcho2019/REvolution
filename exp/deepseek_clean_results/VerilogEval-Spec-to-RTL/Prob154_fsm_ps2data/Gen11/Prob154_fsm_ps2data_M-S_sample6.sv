module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // State encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  if (in[3]) begin
                    out_bytes[23:16] <= in;
                    state <= BYTE1;
                end
                BYTE1: begin
                    out_bytes[15:8] <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    out_bytes[7:0] <= in;
                    state <= IDLE;
                end
            endcase
        end
    end

    assign done = (state == BYTE2);

endmodule