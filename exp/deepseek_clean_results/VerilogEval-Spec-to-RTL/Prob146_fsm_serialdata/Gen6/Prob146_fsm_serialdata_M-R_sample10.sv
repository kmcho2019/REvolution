module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;

    // Next state and output logic
    wire start_bit = (in == 0);
    wire stop_bit = (in == 1);
    wire all_bits_received = (bit_count == 3'd7);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            done_reg <= 0;  // Default value

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (start_bit) begin
                        state <= RECEIVE;
                        data_reg <= 0;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    if (all_bits_received) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (stop_bit) begin
                        state <= IDLE;
                        done_reg <= 1;
                    end
                    // Stay in STOP until stop bit found
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Continuous assignments for outputs
    assign out_byte = data_reg;
    assign done = done_reg;

endmodule