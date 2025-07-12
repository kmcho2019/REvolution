module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding
    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        done = 1'b0;  // default no done
        case(state)
            IDLE: begin
                if (in[3] == 1'b1)
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;    // assert done after third byte
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule