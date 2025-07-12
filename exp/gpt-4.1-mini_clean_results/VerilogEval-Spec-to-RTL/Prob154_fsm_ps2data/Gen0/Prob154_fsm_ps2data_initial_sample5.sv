module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

// State encoding
localparam WAIT_SYNC = 2'd0;
localparam BYTE1     = 2'd1;
localparam BYTE2     = 2'd2;

reg [1:0] state, next_state;
reg [23:0] message_reg;

// Sequential logic for state and message registers
always @(posedge clk) begin
    if (reset) begin
        state <= WAIT_SYNC;
        message_reg <= 24'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;

        case (state)
            WAIT_SYNC: begin
                done <= 1'b0;
                // Wait for in[3] == 1 to start message
                if (in[3] == 1'b1) begin
                    // Store first byte at MSB portion
                    message_reg[23:16] <= in;
                end
            end
            BYTE1: begin
                done <= 1'b0;
                // Store second byte
                message_reg[15:8] <= in;
            end
            BYTE2: begin
                // Store third byte
                message_reg[7:0] <= in;
                done <= 1'b1;            // Assert done for 1 cycle after third byte
                out_bytes <= {message_reg[23:16], message_reg[15:8], in};
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

// Next state logic combinational
always @(*) begin
    next_state = state;
    case (state)
        WAIT_SYNC: begin
            if (in[3] == 1'b1)
                next_state = BYTE1;
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = WAIT_SYNC;
        end
    endcase
end

endmodule