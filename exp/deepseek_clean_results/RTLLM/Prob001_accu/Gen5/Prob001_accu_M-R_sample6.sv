module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam [1:0] IDLE = 2'b00,
                    STATE1 = 2'b01,
                    STATE2 = 2'b10,
                    STATE3 = 2'b11;

    reg [1:0] current_state, next_state;
    reg [9:0] accum_reg;
    wire [9:0] next_accum;

    // Next accumulation value (combinational)
    assign next_accum = accum_reg + data_in;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        if (valid_in) begin
            case (current_state)
                IDLE:   next_state = STATE1;
                STATE1: next_state = STATE2;
                STATE2: next_state = STATE3;
                STATE3: next_state = IDLE;
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            accum_reg <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            valid_out <= 1'b0;

            if (valid_in) begin
                accum_reg <= next_accum;
                
                if (current_state == STATE3) begin
                    data_out <= next_accum;
                    valid_out <= 1'b1;
                    accum_reg <= 10'b0;  // Reset accumulator
                end
            end
        end
    end

endmodule