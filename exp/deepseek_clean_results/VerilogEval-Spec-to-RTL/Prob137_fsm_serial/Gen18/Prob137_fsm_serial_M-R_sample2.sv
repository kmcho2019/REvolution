module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Binary state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT    = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (!in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? (in ? IDLE : WAIT) : RECEIVE;
            WAIT:    next_state = in ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
        end else begin
            state <= next_state;
            
            // Data shift and counter update
            if (state == RECEIVE) begin
                data_reg <= {in, data_reg[7:1]};
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Mealy-style output: done is asserted when we get a valid stop bit
    assign done = (state == RECEIVE) && (bit_count == 3'd7) && in;

endmodule