module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded states
    localparam WAIT_START   = 9'b0000_00001;
    localparam RECEIVE_0    = 9'b0000_00010;
    localparam RECEIVE_1    = 9'b0000_00100;
    localparam RECEIVE_2    = 9'b0000_01000;
    localparam RECEIVE_3    = 9'b0000_10000;
    localparam RECEIVE_4    = 9'b0001_00000;
    localparam RECEIVE_5    = 9'b0010_00000;
    localparam RECEIVE_6    = 9'b0100_00000;
    localparam RECEIVE_7    = 9'b1000_00000;
    localparam CHECK_STOP   = 9'b0000_0000; // will define as a separate reg since 9 bits needed
    localparam ERROR_WAIT   = 9'b0000_0000; // also separate

    // Since we need 11 states (WAIT_START + RECEIVE_0..7 + CHECK_STOP + ERROR_WAIT)
    // define all in a 12-bit one-hot encoding for clarity:

    localparam STATE_WIDTH = 12;

    localparam S_WAIT_START  = 12'b0000_0000_0001;
    localparam S_RECEIVE_0   = 12'b0000_0000_0010;
    localparam S_RECEIVE_1   = 12'b0000_0000_0100;
    localparam S_RECEIVE_2   = 12'b0000_0000_1000;
    localparam S_RECEIVE_3   = 12'b0000_0001_0000;
    localparam S_RECEIVE_4   = 12'b0000_0010_0000;
    localparam S_RECEIVE_5   = 12'b0000_0100_0000;
    localparam S_RECEIVE_6   = 12'b0000_1000_0000;
    localparam S_RECEIVE_7   = 12'b0001_0000_0000;
    localparam S_CHECK_STOP  = 12'b0010_0000_0000;
    localparam S_ERROR_WAIT  = 12'b0100_0000_0000;

    reg [STATE_WIDTH-1:0] state, next_state;

    reg [7:0] data_accumulator;

    // FSM combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            S_WAIT_START: begin
                // Wait for start bit (line goes low)
                if (in == 1'b0)
                    next_state = S_RECEIVE_0;
                else
                    next_state = S_WAIT_START;
            end

            S_RECEIVE_0: next_state = S_RECEIVE_1;
            S_RECEIVE_1: next_state = S_RECEIVE_2;
            S_RECEIVE_2: next_state = S_RECEIVE_3;
            S_RECEIVE_3: next_state = S_RECEIVE_4;
            S_RECEIVE_4: next_state = S_RECEIVE_5;
            S_RECEIVE_5: next_state = S_RECEIVE_6;
            S_RECEIVE_6: next_state = S_RECEIVE_7;
            S_RECEIVE_7: next_state = S_CHECK_STOP;

            S_CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = S_WAIT_START;   // good stop bit, ready for next frame
                else
                    next_state = S_ERROR_WAIT;   // framing error: wait for idle line
            end

            S_ERROR_WAIT: begin
                // Wait for line idle to recover
                if (in == 1'b1)
                    next_state = S_WAIT_START;
                else
                    next_state = S_ERROR_WAIT;
            end

            default: next_state = S_WAIT_START;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S_WAIT_START;
            data_accumulator <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done

            case (state)
                S_WAIT_START: begin
                    data_accumulator <= 8'b0; // Clear accumulator waiting for new frame
                end

                S_RECEIVE_0: begin
                    // LSB first: shift left and add new bit
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_1: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_2: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_3: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_4: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_5: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_6: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_RECEIVE_7: begin
                    data_accumulator <= {in, data_accumulator[7:1]};
                end

                S_CHECK_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;  // Valid stop bit signals successful byte reception
                    // else no done, error handled by next_state logic
                end

                S_ERROR_WAIT: begin
                    // Remain in error recovery until line idle detected
                    // data_accumulator unchanged
                end
            endcase
        end
    end

endmodule