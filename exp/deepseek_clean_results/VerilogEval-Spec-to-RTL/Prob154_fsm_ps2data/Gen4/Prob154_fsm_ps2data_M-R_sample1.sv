module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // State encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE2 = 2'b01;
    localparam [1:0] BYTE3 = 2'b10;

    reg [1:0] state;
    reg [23:0] byte_buffer;

    // Continuous assignments
    assign out_bytes = byte_buffer;
    assign done = (state == BYTE3);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (in[3]) begin
                    byte_buffer[23:16] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    byte_buffer[15:8] <= in;
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    byte_buffer[7:0] <= in;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule