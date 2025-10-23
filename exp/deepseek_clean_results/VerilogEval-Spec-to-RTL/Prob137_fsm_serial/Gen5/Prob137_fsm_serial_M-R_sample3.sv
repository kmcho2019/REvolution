module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Single always block for sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_shift <= 8'b0;
        end else begin
            case (1'b1)
                state[0]: begin // IDLE
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end
                state[1]: begin // RECEIVE
                    data_shift <= {in, data_shift[7:1]}; // LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                state[2]: begin // STOP
                    if (in) begin
                        state <= IDLE;
                    end else begin
                        state <= ERROR;
                    end
                end
                state[3]: begin // ERROR
                    if (in) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output is combinational
    assign done = (state == STOP) && in;

endmodule