module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    // State machine and data collection
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            state <= next_state;
            out_bytes <= next_out_bytes;
            done <= next_done;
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        next_state = state;
        next_out_bytes = out_bytes;
        next_done = 1'b0;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_out_bytes = {in, 16'bx}; // Store first byte
                    next_state = BYTE1;
                end else begin
                    next_out_bytes = 24'bx;
                end
            end
            
            BYTE1: begin
                next_out_bytes = {out_bytes[23:16], in, 8'bx}; // Store second byte
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_out_bytes = {out_bytes[23:16], out_bytes[15:8], in}; // Store third byte
                next_done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule