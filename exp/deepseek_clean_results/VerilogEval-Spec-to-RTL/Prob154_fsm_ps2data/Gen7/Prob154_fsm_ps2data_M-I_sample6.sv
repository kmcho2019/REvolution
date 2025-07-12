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
    localparam [1:0] DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            state <= next_state;
            out_bytes <= next_out_bytes;
            done <= next_done;
        end
    end

    always @(*) begin
        // Default assignments
        next_state = state;
        next_out_bytes = out_bytes;
        next_done = 1'b0;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_out_bytes = {in, 16'bx}; // Only update relevant portion
                    next_state = BYTE1;
                end
            end
            
            BYTE1: begin
                next_out_bytes = {out_bytes[23:16], in, 8'bx};
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_out_bytes = {out_bytes[23:16], out_bytes[15:8], in};
                next_state = DONE;
            end
            
            DONE: begin
                next_done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule