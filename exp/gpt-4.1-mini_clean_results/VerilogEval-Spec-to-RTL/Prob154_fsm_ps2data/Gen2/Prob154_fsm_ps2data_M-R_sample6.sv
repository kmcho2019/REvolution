module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);
    // States
    localparam SEARCH  = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state, next_state;
    reg [1:0] byte_count;     // counts bytes received after start byte (0 to 2)
    reg [23:0] shift_reg;     // shift register to store 3 bytes

    // Next state logic and control signals
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (in[3]) next_state = RECEIVE;
            end
            RECEIVE: begin
                if (byte_count == 2)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic: state, byte_count, shift_reg, outputs
    always @(posedge clk) begin
        if (reset) begin
            state      <= SEARCH;
            byte_count <= 2'd0;
            shift_reg  <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default

            case(state)
                SEARCH: begin
                    byte_count <= 2'd0;
                    if (in[3]) begin
                        // start message, load first byte into MSB part
                        shift_reg <= {in, 16'd0};
                        byte_count <= 2'd1;
                    end
                end

                RECEIVE: begin
                    // shift in new byte at LSB, shift existing bytes left by 8
                    shift_reg <= {shift_reg[15:0], in};
                    if (byte_count == 2) begin
                        // message complete
                        out_bytes <= {shift_reg[15:0], in};
                        done <= 1'b1;
                        byte_count <= 2'd0; // prepare for next SEARCH state
                    end else begin
                        byte_count <= byte_count + 1;
                    end
                end
            endcase
        end
    end
endmodule