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

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg done_reg;
    reg [7:0] data_shift;
    reg data_shift_en;

    // Clock gating for data_shift
    always @(posedge clk) begin
        if (data_shift_en)
            data_shift <= {in, data_shift[7:1]}; // LSB first
    end

    // State and control registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
            data_shift_en <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                bit_count <= bit_count + 1;
                data_shift_en <= 1'b1;
            end else begin
                bit_count <= 3'b0;
                data_shift_en <= 1'b0;
            end

            // Combined done and state transition logic
            if (state == STOP)
                done_reg <= in;
            else if (state != IDLE && state != ERROR)
                done_reg <= 1'b0;
        end
    end

    // Registered next state logic
    always @(posedge clk) begin
        if (reset)
            next_state <= IDLE;
        else begin
            case (state)
                IDLE:   next_state <= (in == 1'b0) ? RECEIVE : IDLE;
                RECEIVE: next_state <= (bit_count == 3'b111) ? STOP : RECEIVE;
                STOP:   next_state <= in ? IDLE : ERROR;
                ERROR:  next_state <= in ? IDLE : ERROR;
                default: next_state <= IDLE;
            endcase
        end
    end

    assign done = done_reg && (state == STOP);

endmodule