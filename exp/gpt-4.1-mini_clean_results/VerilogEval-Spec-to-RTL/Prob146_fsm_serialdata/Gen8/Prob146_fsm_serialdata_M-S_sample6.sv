module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam ERROR_WAIT = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in data LSB first: input bit goes into MSB, shift right
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;

                    if (bit_count == 3'd7) begin
                        // After 8 data bits, next bit is stop bit
                        state <= (in == 1'b1) ? IDLE : ERROR_WAIT;
                        if (in == 1'b1) begin
                            out_byte <= {in, data_shift[7:1]}; // Actually stop bit is not data; output captured data_shift as is
                            // Correction: We shifted in stop bit as data here, so need to output previous data_shift before shift.
                            // So output must be previous data_shift (before shift), which is data_shift[7:0] before this cycle.
                            // Fix by outputting data_shift before shift (from previous cycle).
                            // We can do done and out_byte assignment here but data_shift already shifted in stop bit.
                            // Thus, better to output data_shift before shift:
                            // To fix this, move shift logic after bit_count increment and done assertion.
                            // Simplify by reordering below.
                            done <= 1'b1;
                        end
                    end
                end

                ERROR_WAIT: begin
                    if (in == 1'b1) begin // line idle
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // To fix the output data issue, separate shift logic and done/out_byte assignment.

    // We need to delay output until the stop bit clock cycle.
    // So implement a combinational approach for done and out_byte.

    // Let's move done and out_byte assignments to a separate always block that triggers on state and bit_count:

    // But to keep it simple, reorder the code:

endmodule

module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam ERROR_WAIT = 2'd2;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case(state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                        bit_count <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    if (bit_count < 3'd8) begin
                        data_shift <= {in, data_shift[7:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        // bit_count == 8 means next bit is stop bit (current in)
                        if (in == 1'b1) begin
                            out_byte <= data_shift;
                            done <= 1'b1;
                            state <= IDLE;
                        end else begin
                            state <= ERROR_WAIT;
                        end
                    end
                end

                ERROR_WAIT: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule