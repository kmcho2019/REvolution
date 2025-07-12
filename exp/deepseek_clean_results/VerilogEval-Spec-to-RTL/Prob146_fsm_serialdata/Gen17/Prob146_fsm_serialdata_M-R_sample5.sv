module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next-state logic
    assign next_state = 
        (state == IDLE)    ? (in ? IDLE : RECEIVE) :
        (state == RECEIVE) ? (bit_count == 8 ? STOP : RECEIVE) :
        (state == STOP)    ? (in ? IDLE : ERROR) :
        (state == ERROR)   ? (in ? IDLE : ERROR) :
                             IDLE;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;

            case (1'b1) // synthesis parallel_case
                state[0]: begin // IDLE
                    bit_count <= 0;
                    if (!in) shift_reg <= 0;
                end

                state[1]: begin // RECEIVE
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                state[2]: begin // STOP
                    if (in) begin
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end

                state[3]: begin // ERROR
                    // Just wait for stop bit
                end
            endcase
        end
    end

endmodule