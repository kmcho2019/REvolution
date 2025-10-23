module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam ERROR   = 4'b0100;
    localparam DONE    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg shift_en, count_en;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? (in ? DONE : ERROR) : RECEIVE;
            ERROR:   next_state = in ? IDLE : ERROR;
            DONE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Data handling logic with enable signals
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            if (shift_en) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
            end
            if (count_en) begin
                bit_count <= bit_count + 1;
            end
            if (state == IDLE) begin
                bit_count <= 3'b0;
            end
        end
    end

    // Enable signals generation
    always @(*) begin
        shift_en = (state == RECEIVE);
        count_en = (state == RECEIVE) && (bit_count != 3'b111);
    end

    // Output logic
    assign done = (state == DONE);

endmodule