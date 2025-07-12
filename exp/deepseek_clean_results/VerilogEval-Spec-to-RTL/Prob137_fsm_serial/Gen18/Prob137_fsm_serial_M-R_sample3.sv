module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary encoded states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    wire shift_en;
    wire stop_valid;

    // Moore FSM - state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:    state <= (in == 1'b0) ? RECEIVE : IDLE;
                RECEIVE: state <= (bit_count == 3'b111) ? STOP : RECEIVE;
                STOP:    state <= (in == 1'b1) ? IDLE : WAIT;
                WAIT:   state <= (in == 1'b1) ? IDLE : WAIT;
            endcase
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset || state != RECEIVE) begin
            bit_count <= 3'b0;
        end else begin
            bit_count <= bit_count + 1;
        end
    end

    // Data shift register with explicit enable
    assign shift_en = (state == RECEIVE) || (state == IDLE && in == 1'b0);
    always @(posedge clk) begin
        if (shift_en) begin
            data_reg <= {in, data_reg[7:1]};  // LSB first
        end
    end

    // Output logic
    assign stop_valid = (state == STOP) && (in == 1'b1);
    assign done = stop_valid;

endmodule