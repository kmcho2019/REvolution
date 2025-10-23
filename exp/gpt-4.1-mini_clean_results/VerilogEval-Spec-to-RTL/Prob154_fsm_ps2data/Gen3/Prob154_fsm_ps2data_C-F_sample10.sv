module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM state encoding
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state;
    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'b0;
            byte2     <= 8'b0;
            out_bytes <= 24'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    // Wait for byte with in[3]==1 to start message
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE2;
                    end
                end

                BYTE2: begin
                    byte2 <= in;
                    state <= BYTE3;
                end

                BYTE3: begin
                    // Output complete message and assert done
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule