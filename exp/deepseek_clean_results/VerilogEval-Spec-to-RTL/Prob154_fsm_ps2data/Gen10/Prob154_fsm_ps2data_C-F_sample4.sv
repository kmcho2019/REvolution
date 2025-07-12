module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;
    reg byte_enable;  // Enable signal for shift register

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        next_out_bytes = out_bytes;
        next_done = 1'b0;
        byte_enable = 1'b0;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE1;
                    next_out_bytes = {in, 16'b0};  // Shift in first byte
                    byte_enable = 1'b1;
                end
            end
            
            BYTE1: begin
                next_state = BYTE2;
                next_out_bytes = {out_bytes[23:16], in, 8'b0};  // Shift in second byte
                byte_enable = 1'b1;
            end
            
            BYTE2: begin
                next_state = IDLE;
                next_out_bytes = {out_bytes[23:8], in};  // Shift in third byte
                next_done = 1'b1;
                byte_enable = 1'b1;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            state <= next_state;
            done <= next_done;
            if (byte_enable) begin
                out_bytes <= next_out_bytes;
            end
        end
    end

endmodule