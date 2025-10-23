module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    typedef enum reg [1:0] {
        WAIT_START = 2'd0,
        BYTE_2     = 2'd1,
        BYTE_3     = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    always @(*) begin
        done = 1'b0;
        case (state)
            WAIT_START: begin
                if (in[3])
                    next_state = BYTE_2;
                else
                    next_state = WAIT_START;
            end
            BYTE_2: begin
                next_state = BYTE_3;
            end
            BYTE_3: begin
                next_state = WAIT_START;
                done = 1'b1; // done immediately after third byte
            end
            default: begin
                next_state = WAIT_START;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done;  // done assigned in combinational, registered here
        end
    end

endmodule