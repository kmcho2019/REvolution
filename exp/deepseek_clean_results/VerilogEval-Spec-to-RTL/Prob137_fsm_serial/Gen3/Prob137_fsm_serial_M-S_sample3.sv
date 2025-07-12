module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default clear

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                        shift_reg <= 8'b0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        state <= IDLE;
                        done_reg <= 1'b1;  // Valid stop bit
                    end
                    // Else stay in STOP (equivalent to old ERROR state)
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule