module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {IDLE=1'b0, WAIT_SECOND_BYTE=1'b1} state_t;
    state_t state, next_state;

    reg [7:0] data_lock;       // holds first byte
    reg [15:0] data_out_next;
    reg valid_out_next;

    // State transition and output logic
    always @(*) begin
        // Default assignments
        next_state     = state;
        data_out_next  = data_out;
        valid_out_next = 1'b0;

        case(state)
            IDLE: begin
                if(valid_in) begin
                    next_state = WAIT_SECOND_BYTE;
                    // no output yet, just store first byte
                    valid_out_next = 1'b0;
                    // data_out_next unchanged
                end
            end
            WAIT_SECOND_BYTE: begin
                if(valid_in) begin
                    // On second valid_in, output concatenated data next cycle
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b1;
                    next_state     = IDLE;
                end
                else begin
                    // wait here until next valid_in arrives
                    valid_out_next = 1'b0;
                end
            end
        endcase
    end

    // State and registers update on clock edge
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= valid_out_next;
            // Update data_lock only on first byte arrival
            if(state == IDLE && valid_in) begin
                data_lock <= data_in;
            end
            // Update data_out only when valid_out asserted
            if(valid_out_next) begin
                data_out <= data_out_next;
            end
        end
    end

endmodule