module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE2;
                end
                BYTE2: state <= BYTE3;
                BYTE3: begin
                    state <= IDLE;
                    done <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule