module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State transitions
    wire to_idle    = (state == STOP && in) || (state == ERROR && in);
    wire to_receive = (state == IDLE && ~in);
    wire to_stop    = (state == RECEIVE && bit_count == 3'b111);
    wire to_error   = (state == STOP && ~in);

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (1'b1)  // synthesis parallel_case
                to_idle:    state <= IDLE;
                to_receive: state <= RECEIVE;
                to_stop:    state <= STOP;
                to_error:   state <= ERROR;
                default:   state <= state;
            endcase
        end
    end

    // Data shift register
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset || state == IDLE) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end
    end

    // Done signal - asserted only when valid stop bit received
    assign done = (state == STOP) && in;

endmodule