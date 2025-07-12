module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // One-hot FSM encoding
    localparam IDLE   = 3'b001;
    localparam BYTE2  = 3'b010;
    localparam BYTE3  = 3'b100;

    reg [2:0] state, next_state;

    reg [23:0] msg_shiftreg; // Shift register to hold 3 bytes

    // Synchronous state and datapath update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_shiftreg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default no done

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        // Accept first byte, load into MSByte of shiftreg
                        msg_shiftreg <= {in, 16'd0};
                    end
                end

                BYTE2: begin
                    // Shift left by 8 bits, insert second byte at lower 16 bits
                    msg_shiftreg <= {msg_shiftreg[15:0], in};
                end

                BYTE3: begin
                    // Shift in third byte and assert done
                    msg_shiftreg <= {msg_shiftreg[15:0], in};
                    done <= 1'b1;
                    out_bytes <= {msg_shiftreg[23:8], in}; // updated output, with byte3 = in
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:   next_state = in[3] ? BYTE2 : IDLE;
            BYTE2:  next_state = BYTE3;
            BYTE3:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule