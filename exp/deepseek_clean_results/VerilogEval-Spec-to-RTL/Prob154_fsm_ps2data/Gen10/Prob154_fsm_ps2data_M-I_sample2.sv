module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] BYTE1 = 2'b01;
    localparam [1:0] BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] next_out_bytes;
    reg next_done;

    // Output registers
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            out_bytes <= next_out_bytes;
            done_reg <= next_done;
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
                    next_out_bytes[23:16] = in; // Store first byte
                    next_state = BYTE1;
                end
            end
            
            BYTE1: begin
                next_out_bytes[15:8] = in; // Store second byte
                next_state = BYTE2;
            end
            
            BYTE2: begin
                next_out_bytes[7:0] = in; // Store third byte
                next_done = 1'b1;         // Will be registered next cycle
                next_state = IDLE;
            end
        endcase
    end

    assign done = done_reg;

endmodule