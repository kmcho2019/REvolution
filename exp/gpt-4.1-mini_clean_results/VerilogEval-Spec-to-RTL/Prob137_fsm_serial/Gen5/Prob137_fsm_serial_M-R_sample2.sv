module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary encoded FSM states
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Sequential logic: state, bit_count, data_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left data_reg by 1, insert 'in' bit at LSB
                    // This also assembles bits LSB first as they arrive
                    data_reg <= {in, data_reg[7:1]}; // Wait, this is right shift with MSB insertion (original)
                    // Refactor: to shift left inserting at LSB:
                    // data_reg <= {data_reg[6:0], in};
                    // We'll do that instead in combinational next_state block to keep state updation clean.
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    // Wait for stop bit 1
                end

                default: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end
            endcase
        end
    end

    // For clarity, move data shift into a separate register updated only in RECEIVE state:
    // We'll create a wire 'shifted_data' representing shifted data_reg with incoming bit inserted at LSB.
    wire [7:0] shifted_data = {data_reg[6:0], in}; // shift left, insert at LSB, LSB first order preserved

    // On RECEIVE, load shifted_data into data_reg; otherwise, keep data_reg unchanged.
    always @(posedge clk) begin
        if (reset) begin
            data_reg <= 8'd0;
        end else if (state == RECEIVE) begin
            data_reg <= shifted_data;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit valid
                else
                    next_state = WAIT_STOP; // Wait for valid stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule