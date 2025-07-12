module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam RECV  = 4'b0010;
    localparam STOP  = 4'b0100;
    localparam WAIT  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    wire      valid_stop;

    // State transition (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Shift register operation (sequential)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
        end else if (state == RECV) begin
            shift_reg <= {in, shift_reg[7:1]};  // LSB first
            bit_count <= bit_count + 1;
        end else if (state == IDLE) begin
            bit_count <= 3'b0;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case (1'b1)  // Synthesis will optimize this for one-hot
            state[0]: if (~in) next_state = RECV;  // IDLE
            state[1]: if (bit_count == 3'd7) next_state = STOP;  // RECV
            state[2]: begin  // STOP
                if (in) next_state = IDLE;
                else next_state = WAIT;
            end
            state[3]: if (in) next_state = IDLE;  // WAIT
        endcase
    end

    // Output logic (combinational)
    assign valid_stop = (state == STOP) & in;
    assign done = valid_stop;

endmodule