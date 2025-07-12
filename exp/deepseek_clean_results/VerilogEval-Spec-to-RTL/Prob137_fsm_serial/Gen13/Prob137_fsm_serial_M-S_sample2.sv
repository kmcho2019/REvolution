module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // States
    localparam IDLE    = 1'b0;
    localparam ACTIVE  = 1'b1;

    reg state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == ACTIVE) begin
                if (bit_count != 3'b111) begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
            end else begin
                bit_count <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in == 1'b0) ? ACTIVE : IDLE;
            ACTIVE: begin
                if (bit_count == 3'b111)
                    next_state = (in == 1'b1) ? IDLE : ACTIVE;
                else
                    next_state = ACTIVE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Done pulse when valid stop bit received
    assign done = (state == ACTIVE) && (bit_count == 3'b111) && (in == 1'b1);

endmodule