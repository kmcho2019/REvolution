module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Binary state encoding
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state;
    reg [23:0] next_out_bytes;

    // Combinational done signal
    assign done = (state == BYTE3);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        next_out_bytes[23:16] <= in;
                        state <= BYTE2;
                    end
                end
                
                BYTE2: begin
                    next_out_bytes[15:8] <= in;
                    state <= BYTE3;
                end
                
                BYTE3: begin
                    next_out_bytes[7:0] <= in;
                    out_bytes <= next_out_bytes;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Update out_bytes only when complete message is received
    always @(posedge clk) begin
        if (state == BYTE3) begin
            out_bytes <= {next_out_bytes[23:8], in};
        end
    end

endmodule