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

    reg state;
    reg [7:0] data_lock;       // store first 8-bit input
    reg [7:0] data_second;     // store second 8-bit input (for output)
    reg       ready_to_output; // flag indicates output should be generated this cycle

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= IDLE;
            data_lock       <= 8'd0;
            data_second     <= 8'd0;
            ready_to_output <= 1'b0;
            valid_out       <= 1'b0;
            data_out        <= 16'd0;
        end else begin
            valid_out <= 1'b0;          // default output valid low

            if (ready_to_output) begin
                // Output data one cycle after second input
                data_out        <= {data_lock, data_second};
                valid_out      <= 1'b1;
                ready_to_output <= 1'b0; // clear output flag after output
                data_lock      <= 8'd0;  // clear stored first data
                data_second    <= 8'd0;  // clear second data
                state          <= IDLE;  // back to IDLE to await next data
            end else begin
                case(state)
                    IDLE: begin
                        if (valid_in) begin
                            // Store first input and move to HOLD state
                            data_lock <= data_in;
                            state     <= HOLD;
                        end
                    end
                    HOLD: begin
                        if (valid_in) begin
                            // Second valid input arrived, store it and prepare output next cycle
                            data_second     <= data_in;
                            ready_to_output <= 1'b1;
                            // Hold state until output is generated and ready_to_output cleared
                        end
                    end
                endcase
            end
        end
    end

endmodule