module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,   // Waiting for the first 0 of the pulse
        GOT_0 = 2'd1,  // Detected first 0, expecting 1 next
        GOT_01 = 2'd2  // Detected 0 then 1, expecting final 0
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= 1'b0;  // default to 0 each cycle, pulse asserted only on detecting final 0
            case(state)
                IDLE: begin
                    if (data_in == 1'b0)
                        next_state <= GOT_0;
                    else
                        next_state <= IDLE;
                end
                GOT_0: begin
                    if (data_in == 1'b1)
                        next_state <= GOT_01;
                    else if (data_in == 1'b0)
                        next_state <= GOT_0; // stay in GOT_0 if repeated zeros
                    else
                        next_state <= IDLE;
                end
                GOT_01: begin
                    if (data_in == 1'b0) begin
                        next_state <= IDLE;
                        data_out <= 1'b1; // pulse detected on final 0
                    end else if (data_in == 1'b1) begin
                        next_state <= GOT_01; // stay if 1 repeats (unlikely for pulse)
                    end else begin
                        next_state <= IDLE;
                    end
                end
                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule