module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // FSM states
    localparam IDLE  = 2'd0;
    localparam BYTE1 = 2'd1;
    localparam BYTE2 = 2'd2;
    localparam BYTE3 = 2'd3;

    reg [1:0] state;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low
            case(state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    out_bytes <= {byte1, byte2, byte3};
                    done      <= 1'b1;
                    state     <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule