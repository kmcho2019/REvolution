module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam DONE    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_enable;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_enable <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            shift_enable <= 1'b0;

            case (state)
                IDLE: begin
                    if (!in) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'd7;  // Count down from 7 to 0
                        shift_enable <= 1'b1;
                    end
                end

                RECEIVE: begin
                    if (bit_count == 3'b0) begin
                        // Check stop bit immediately after last data bit
                        if (in) begin  // Valid stop bit
                            out_byte <= {in, shift_reg[7:1]};  // Final shift
                            done <= 1'b1;
                            state <= DONE;
                        end else begin  // Missing stop bit
                            state <= IDLE;  // Immediate reset
                        end
                    end else begin
                        shift_reg <= {in, shift_reg[7:1]};  // LSB first
                        bit_count <= bit_count - 1;
                        shift_enable <= 1'b1;
                    end
                end

                DONE: begin
                    state <= IDLE;  // Single-cycle done state
                end
            endcase
        end
    end

    // Conditional shift operation to save power
    always @(posedge clk) begin
        if (shift_enable) begin
            shift_reg <= {in, shift_reg[7:1]};
        end
    end

endmodule