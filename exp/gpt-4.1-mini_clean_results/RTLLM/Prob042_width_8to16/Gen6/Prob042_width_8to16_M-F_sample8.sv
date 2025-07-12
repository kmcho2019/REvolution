module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam HOLD = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;    // store first input
    reg [7:0] data_second;  // store second input (for output next cycle)
    reg       output_flag;  // flag to generate output at next cycle

    // Sequential logic: state, registers, output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            data_second <= 8'd0;
            output_flag <= 1'b0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            // Default valid_out low each cycle, set high only when output_flag
            valid_out <= 1'b0;

            // Output generation on output_flag assertion
            if (output_flag) begin
                data_out  <= {data_lock, data_second};
                valid_out <= 1'b1;
                output_flag <= 1'b0; // clear output_flag after output
                // After output, clear stored data_lock and go to IDLE
                state <= IDLE;
            end else begin
                // State transitions and data storing
                case (state)
                    IDLE: begin
                        if (valid_in) begin
                            data_lock <= data_in;
                            state <= HOLD;
                        end
                    end
                    HOLD: begin
                        if (valid_in) begin
                            data_second <= data_in;
                            output_flag <= 1'b1; // generate output next cycle
                            // state updated to IDLE only after output_flag clears in next cycle
                        end
                    end
                    default: state <= IDLE;
                endcase
            end
        end
    end

endmodule