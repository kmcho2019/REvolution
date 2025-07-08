module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // State encoding
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        next_state <= BYTE1;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                BYTE1: begin
                    byte2 <= in;
                    next_state <= BYTE2;
                end

                BYTE2: begin
                    byte3 <= in;
                    // output message and assert done next cycle
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    next_state <= IDLE;
                end

                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule