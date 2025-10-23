module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    localparam SEARCH  = 1'b0;
    localparam CAPTURE = 1'b1;

    reg state, next_state;

    reg [23:0] shift_reg;
    reg [1:0] byte_count; // Counts from 0 to 2 during CAPTURE

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 24'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case(state)
                SEARCH: begin
                    if (in[3]) begin
                        // Start of message detected: load first byte into bits[23:16]
                        shift_reg <= {in, 16'b0};
                        byte_count <= 2'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in next byte at lower 16 bits; shift left by 8 bits, append new byte
                    shift_reg <= {shift_reg[15:0], in};

                    if (byte_count == 2) begin
                        // After third byte (index 2) received, signal done and output message
                        done <= 1'b1;
                        out_bytes <= {shift_reg[15:0], in};
                    end

                    byte_count <= byte_count + 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH: next_state = (in[3]) ? CAPTURE : SEARCH;
            CAPTURE: next_state = (byte_count == 2) ? SEARCH : CAPTURE;
            default: next_state = SEARCH;
        endcase
    end

endmodule