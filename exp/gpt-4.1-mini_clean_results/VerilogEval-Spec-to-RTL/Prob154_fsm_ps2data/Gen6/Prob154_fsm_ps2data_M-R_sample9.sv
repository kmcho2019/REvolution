module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

// Binary state encoding
localparam WAIT_SYNC = 2'b00;
localparam BYTE1     = 2'b01;
localparam BYTE2     = 2'b10;

reg [1:0] state, next_state;

// Shift register for message bytes
reg [23:0] message_shift;

// Sequential block: state, message_shift, done, out_bytes
always @(posedge clk) begin
    if (reset) begin
        state       <= WAIT_SYNC;
        message_shift <= 24'd0;
        out_bytes   <= 24'd0;
        done        <= 1'b0;
    end else begin
        state <= next_state;
        done  <= 1'b0; // default deassert done

        case(state)
            WAIT_SYNC: begin
                if (in[3]) begin
                    // Load first byte in highest 8 bits, clear rest
                    message_shift <= {in, 16'd0};
                end
            end
            BYTE1: begin
                // Shift in second byte (middle 8 bits)
                message_shift <= {message_shift[15:0], in};
            end
            BYTE2: begin
                // Shift in third byte (lowest 8 bits)
                message_shift <= {message_shift[15:0], in};
                done <= 1'b1;  // done asserted after 3rd byte captured
                out_bytes <= {message_shift[23:16], message_shift[15:8], in};
            end
        endcase
    end
end

// Combinational next state logic
always @(*) begin
    case(state)
        WAIT_SYNC: next_state = in[3] ? BYTE1 : WAIT_SYNC;
        BYTE1:     next_state = BYTE2;
        BYTE2:     next_state = WAIT_SYNC;
        default:   next_state = WAIT_SYNC;
    endcase
end

endmodule