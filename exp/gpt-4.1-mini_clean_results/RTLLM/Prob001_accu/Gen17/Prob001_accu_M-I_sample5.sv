module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        ACCUM_1    = 2'b01,
        ACCUM_2    = 2'b10,
        OUTPUT     = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Pipeline registers for input data staging and partial sums
    reg [7:0] data_stage1, data_stage2, data_stage3, data_stage4;
    reg [9:0] sum_stage1, sum_stage2, sum_stage3;

    // State machine for controlling accumulation over 4 cycles
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic based on valid_in and current state
    always @(*) begin
        case (state)
            IDLE:
                next_state = valid_in ? ACCUM_1 : IDLE;
            ACCUM_1:
                next_state = valid_in ? ACCUM_2 : ACCUM_1;
            ACCUM_2:
                next_state = valid_in ? OUTPUT : ACCUM_2;
            OUTPUT:
                next_state = valid_in ? ACCUM_1 : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Pipeline input data sampling only on valid_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_stage1 <= 8'd0;
            data_stage2 <= 8'd0;
            data_stage3 <= 8'd0;
            data_stage4 <= 8'd0;
            sum_stage1  <= 10'd0;
            sum_stage2  <= 10'd0;
            sum_stage3  <= 10'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low each cycle

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_stage1 <= data_in;
                    end
                end
                ACCUM_1: begin
                    if (valid_in) begin
                        data_stage2 <= data_in;
                        // First addition: stage1 + stage2
                        sum_stage1 <= data_stage1 + data_in;
                    end
                end
                ACCUM_2: begin
                    if (valid_in) begin
                        data_stage3 <= data_in;
                        // Second addition: sum_stage1 + data_stage3
                        sum_stage2 <= sum_stage1 + data_in;
                    end
                end
                OUTPUT: begin
                    if (valid_in) begin
                        data_stage4 <= data_in;
                        // Final addition: sum_stage2 + data_stage4
                        sum_stage3 <= sum_stage2 + data_in;

                        // Output the accumulated sum
                        data_out  <= sum_stage2 + data_in;
                        valid_out <= 1'b1;
                    end else begin
                        valid_out <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule