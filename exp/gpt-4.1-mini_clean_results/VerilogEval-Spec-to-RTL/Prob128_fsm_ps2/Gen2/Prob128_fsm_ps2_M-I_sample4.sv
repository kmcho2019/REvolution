module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding using localparams for synthesis friendliness
    localparam IDLE  = 2'b00;
    localparam RXMSG = 2'b01;

    reg [1:0] state, next_state;
    reg [1:0] byte_count, next_byte_count; // counts bytes received in a message (0 to 2)

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            done       <= 1'b0;
        end else begin
            state      <= next_state;
            byte_count <= next_byte_count;
            // done pulse when byte_count reaches 2 in RXMSG state, i.e. after third byte received
            done       <= (state == RXMSG) && (byte_count == 2'd2);
        end
    end

    always @(*) begin
        // Default assignments
        next_state      = state;
        next_byte_count = byte_count;

        case (state)
            IDLE: begin
                done = 1'b0; // no done in IDLE
                if (in[3]) begin
                    // first byte detected, move to RXMSG and count first byte
                    next_state      = RXMSG;
                    next_byte_count = 2'd0; // count first byte as 0-based
                end else begin
                    next_state      = IDLE;
                    next_byte_count = 2'd0;
                end
            end
            RXMSG: begin
                if (byte_count < 2) begin
                    // receive next byte
                    next_byte_count = byte_count + 1'b1;
                    next_state      = RXMSG;
                end else begin
                    // after third byte, return to IDLE to look for next message start
                    next_byte_count = 2'd0;
                    next_state      = IDLE;
                end
            end
            default: begin
                next_state      = IDLE;
                next_byte_count = 2'd0;
            end
        endcase
    end

endmodule