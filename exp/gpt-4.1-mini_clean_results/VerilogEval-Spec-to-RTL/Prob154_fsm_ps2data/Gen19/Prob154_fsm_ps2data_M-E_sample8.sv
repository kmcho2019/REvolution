module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg   done
);

    // FSM states
    localparam IDLE      = 1'b0;
    localparam RECEIVING = 1'b1;

    reg state;
    reg [1:0] byte_count;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            byte_count <= 2'd0;
            shift_reg  <= 24'd0;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default no done each cycle

            case(state)
                IDLE: begin
                    if (in[3]) begin
                        // Start byte detected: load into highest byte
                        shift_reg  <= {in, 16'd0};
                        byte_count <= 2'd1;
                        state      <= RECEIVING;
                    end
                end

                RECEIVING: begin
                    // Shift new byte into lower bytes
                    shift_reg <= {shift_reg[15:0], in};
                    byte_count <= byte_count + 2'd1;

                    if (byte_count == 2'd2) begin
                        // Just received third byte, output message and signal done
                        out_bytes <= {shift_reg[15:0], in};
                        done      <= 1'b1;
                        state     <= IDLE;
                        byte_count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule