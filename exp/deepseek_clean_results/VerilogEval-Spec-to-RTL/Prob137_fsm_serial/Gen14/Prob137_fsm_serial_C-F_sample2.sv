module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding (binary for area efficiency)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;
    localparam WAIT    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end

    // Data shift register (LSB first)
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
        end else if (state == RECEIVE) begin
            data_reg <= {in, data_reg[7:1]};
        end
    end

    // Done signal (single-cycle pulse)
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else begin
            done <= (state == STOP && in);
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : WAIT;
            WAIT:    next_state = in ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

endmodule