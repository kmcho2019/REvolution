module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // One-hot encoded states
    localparam WAIT_START = 3'b001;
    localparam BYTE2      = 3'b010;
    localparam BYTE3      = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default no done unless state BYTE3 completed below
            case (state)
                WAIT_START: begin
                    if (in[3])
                        state <= BYTE2;
                    else
                        state <= WAIT_START;
                end
                BYTE2: begin
                    state <= BYTE3;
                end
                BYTE3: begin
                    state <= WAIT_START;
                    done  <= 1'b1; // assert done only one cycle after third byte
                end
                default: begin
                    state <= WAIT_START;
                end
            endcase
        end
    end

endmodule